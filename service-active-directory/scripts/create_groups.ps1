$ENVIROMENTS = (
    "alfresco-dev",
    "cr-jira-dev",
    "cr-jira-prod",
    "cr-jitbit-dev",
    "cr-jitbit-prod",
    "cr-unpaid-work-dev",
    "cr-unpaid-work-prod",
    "delius-auto-test",
    "delius-core-dev",
    "delius-core-sandpit",
    "delius-mis-dev",
    "delius-mis-test",
    "delius-perf",
    "delius-po-test1",
    "delius-pre-prod",
    "delius-prod",
    "delius-stage",
    "delius-test",
    "delius-training",
    "delius-training-test"
)

foreach ($ENV in $ENVIROMENTS)
{
     NEW-ADGroup –name $ENV –groupscope Global –path "OU=Users,OU=bastion-dev,DC=bastion-dev,DC=local" 

}
