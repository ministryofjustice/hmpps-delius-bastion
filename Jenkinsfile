def get_terraform_container() {
    sh '''
        docker pull mojdigitalstudio/hmpps-terraform-builder:latest
    '''
}

def plan_submodule(submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        set +e
        docker run --rm -v `pwd`:/home/tools/data -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder bash -c "\
            source env_configs/${environment_type}.properties.sh; \
            cd $submodule_name; \
            terragrunt plan -detailed-exitcode --out ${environment_type}.plan" || exitcode="\$?" ; echo "\$exitcode" > plan_ret; if [ "\$exitcode" == '1' ]; then exit 1; else exit 0; fi
        set -e
        """
        return readFile('plan_ret').trim()
    }
}

def apply_submodule(submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        docker run --rm -v `pwd`:/home/tools/data -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder bash -c "\
            source env_configs/${environment_type}.properties.sh; \
            cd $submodule_name; \
            terragrunt apply ${environment_type}.plan"
        """
    }
}

def confirm() {
    try {
        timeout(time: 60, unit: 'SECONDS') {
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

def do_terraform(component) {
    if (plan_submodule(component) == "2") {
        confirm()
        if (env.Continue == "true") {
            apply_submodule(component)
        }
    }
    else {
        env.Continue = true
    }
}

pipeline {

    agent { label "jenkins_slave" }

    parameters{
        choice(
            choices:['dev', 'prod'],
            description: 'Select the environment bastion you would like to manage',
            name: 'environment_type'
        )
    }

    stages {

        stage('setup') {
            steps {
                checkout scm
                get_terraform_container()
            }
        }

        stage('Network') {
            steps {
                do_terraform('bastion-vpc')
            }
        }

        stage('Service') {
            steps {
                do_terraform('service-bastion')
            }
        }

    }
}
