def project = [:]
project.bastion_access  = 'hmpps-delius-bastion'

// Parameters required for job
// parameters:
//     choice:
//       name: 'environment_name' [ dev | prod ]
//       description: 'The Engineering Platform environment to configure'
//     booleanParam:
//       name: 'confirmation'
//       description: 'Whether to require manual confirmation of terraform plans.'


def prepare_env() {
    sh '''
    #!/usr/env/bin bash
    docker pull mojdigitalstudio/hmpps-terraform-builder:latest
    '''
}

def plan_submodule(env_name, git_project_dir, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF PLAN for ${env_name} | ${submodule_name} - component from git project ${git_project_dir}"
        set +e
        cd "${git_project_dir}"
        docker run --rm \
            -v `pwd`:/home/tools/data \
            -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
            bash -c "\
                source env_configs/${env_name}.properties; \
                if [ '${env_name}' == 'dev' ]; then unset TERRAGRUNT_IAM_ROLE; fi; \
                cd ${submodule_name}; \
                if [ -d .terraform ]; then rm -rf .terraform; fi; sleep 5; \
                terragrunt init; \
                terragrunt plan -detailed-exitcode --out ${env_name}.plan > tf.plan.out; \
                exitcode=\\\"\\\$?\\\"; \
                cat tf.plan.out; \
                if [ \\\"\\\$exitcode\\\" == '1' ]; then exit 1; fi; \
                if [ \\\"\\\$exitcode\\\" == '2' ]; then \
                    parse-terraform-plan -i tf.plan.out | jq '.changedResources[] | (.action != \\\"update\\\") or (.changedAttributes | to_entries | map(.key != \\\"tags.source-hash\\\") | reduce .[] as \\\$item (false; . or \\\$item))' | jq -e -s 'reduce .[] as \\\$item (false; . or \\\$item) == false'; \
                    if [ \\\"\\\$?\\\" == '1' ]; then exitcode=2 ; else exitcode=3; fi; \
                fi; \
                echo \\\"\\\$exitcode\\\" > plan_ret;" \
            || exitcode="\$?"; \
            if [ "\$exitcode" == '1' ]; then exit 1; else exit 0; fi
        set -e
        """
        return readFile("${git_project_dir}/${submodule_name}/plan_ret").trim()
    }
}

def apply_submodule(env_name, git_project_dir, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF APPLY for ${env_name} | ${submodule_name} - component from git project ${git_project_dir}"
        set +e
        cd "${git_project_dir}"
        docker run --rm \
          -v `pwd`:/home/tools/data \
          -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
          bash -c " \
              source env_configs/${env_name}.properties; \
              if [ '${env_name}' == 'dev' ]; then unset TERRAGRUNT_IAM_ROLE; fi; \
              cd ${submodule_name}; \
              terragrunt apply ${env_name}.plan; \
              tgexitcode=\\\$?; \
              echo \\\"TG exited with code \\\$tgexitcode\\\"; \
              if [ \\\$tgexitcode -ne 0 ]; then \
                exit  \\\$tgexitcode; \
              else \
                exit 0; \
              fi;"; \
        dockerexitcode=\$?; \
        echo "Docker step exited with code \$dockerexitcode"; \
        if [ \$dockerexitcode -ne 0 ]; then exit \$dockerexitcode; else exit 0; fi;
        set -e
        """
    }
}

def confirm() {
    try {
        timeout(time: 15, unit: 'MINUTES') {

            env.Continue = input(
                id: 'Proceed1', message: 'Apply plan?', parameters: [
                    [$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Apply Terraform']
                ]
            )
        }
    } catch(err) { // timeout reached or input false
        def user = err.getCauses()[0].getUser()
        env.Continue = false
        if('SYSTEM' == user.toString()) { // SYSTEM means timeout.
            echo "Timeout"
            error("Build failed because confirmation timed out")
        } else {
            echo "Aborted by: [${user}]"
        }
    }
}

def do_terraform(env_name, git_project, component) {
    plancode = plan_submodule(env_name, git_project, component)
    if (plancode == "2") {
        if ("${confirmation}" == "true") {
           confirm()
        } else {
            env.Continue = true
        }
        if (env.Continue == "true") {
           apply_submodule(env_name, git_project, component)
        }
    }
    else if (plancode == "3") {
        apply_submodule(env_name, git_project, component)
        env.Continue = true
    }
    else {
        env.Continue = true
    }
}

pipeline {

    agent { label "jenkins_slave" }

    options {
      disableConcurrentBuilds()
    }

    stages {

        stage('setup') {
            steps {
              println("Bastion/Access environment name: ${environment_name}")

              slackSend(message: "\"Apply\" started on ${environment_name} Bastion/Access - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL.replace(':8080','')}|Open>)")

              dir( project.eng_platform ) {
                git url: 'git@github.com:ministryofjustice/' + project.bastion_access, branch: 'issue54_DAM-333_Exetend_VPC', credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
              }

              prepare_env()
            }
        }

        stage('Network') {
            steps {
                do_terraform(environment_name, project.bastion_access, 'bastion-vpc')
            }
        }

        stage('Routes') {
            steps {
                do_terraform(environment_name, project.bastion_access, 'routes')
            }
        }

        stage('Service') {
            steps {
                do_terraform(environment_name, project.bastion_access, 'service-bastion')
            }
        }
    }

    post {
      always {
        deleteDir()
      }
      success {
        slackSend(message: "\"Apply\" completed on ${environment_name} Bastion/Access - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'good')
      }
      failure {
        slackSend(message: "\"Apply\" failed on ${environment_name} Bastion/Access - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'danger')
      }
    }

}
