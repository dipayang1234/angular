#!/bin/bash
UserName=dipayang1234
AppPassword=wMR2z478ZhW5X4jFPbtv
workspacename=dipayang1234
#echo "Enter the repository name: "
#read reponame
reponame=$1
echo $reponame
ProjectKey=HEL2
groupslug=Deployment_test

#Repository Creation
curl -X POST  -u $UserName:$AppPassword  https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame  -H "Content-Type: application/json" -d '{"is_private": true, "language": "nodejs", "project": {"key": "'"$ProjectKey"'" } ,"description":"Description_for_the_repository"}'

#Branching Model
curl -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/src -F "branch=main"
curl -X  POST -v -u $UserName:$AppPassword -H "Content-Type:application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/refs/branches -d '{"name": "dev","target":{"hash":"main"}}'
curl -X  PUT -v -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branching-model/settings -H  "Content-Type:application/json" -d '{"development": {"is_valid": true, "name": "dev", "use_mainbranch": false}, "branch_types": [{"kind": "release", "enabled": true, "prefix": "release/"}, {"kind": "hotfix", "enabled": true, "prefix": "hotfix/"}, {"kind": "feature", "enabled": true, "prefix": "feature/"}, {"kind": "bugfix", "enabled": true, "prefix": "bugfix/"}], "production": {"is_valid": true, "enabled": true, "name": "main", "use_mainbranch": false},"type": "branching_model_settings", "links": {"self": {"href": "https://api.bitbucket.org/2.0/repositories/dipayang1234/bitbucket_test3/branching-model/settings"}}}'

curl -X  POST -v -u $UserName:$AppPassword -H "Content-Type:application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/refs/branches -d '{"name": "release","target":{"hash":"dev"}}'
curl -X  POST -v -u $UserName:$AppPassword -H "Content-Type:application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/refs/branches -d '{"name": "bat","target":{"hash":"release"}}'

#Pipeline enabling
curl -X PUT -is -u $UserName:$AppPassword -H 'Content-Type: application/json' https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/pipelines_config -d '{ "enabled": true}'

#Pushing pipeline to dev branch
curl -X POST -is -u $UserName:$AppPassword "Content-Type:application/yaml"  https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/src/ -F bitbucket-pipelines.yml=@pipeline/bitbucket-pipelines.yml -F "branch=dev" -F "message=Uploading yml file using curl command"

#Environment creation
curl   -X POST -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/environments/ -H 'Content-Type:application/json' -d '{"environment_type":{"name":"Test"},"name":"INT0"}'
curl   -X POST -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/environments/ -H 'Content-Type:application/json' -d '{"environment_type":{"name":"Test"},"name":"INT1"}'
curl   -X POST -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/environments/ -H 'Content-Type:application/json' -d '{"environment_type":{"name":"Test"},"name":"INT2"}'
curl   -X POST -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/environments/ -H 'Content-Type:application/json' -d '{"environment_type":{"name":"Test"},"name":"INTDR"}'
curl   -X POST -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/environments/ -H 'Content-Type:application/json' -d '{"environment_type":{"name":"Test"},"name":"CRT"}'
curl   -X POST -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/environments/ -H 'Content-Type:application/json' -d '{"environment_type":{"name":"Test"},"name":"CRTDR"}'
curl   -X POST -u UserName:AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/environments/ -H 'Content-Type:application/json' -d '{"environment_type":{"name":"Test"},"name":"BAT", ,"restrictions": {"admin_only": true, "type": "deployment_restrictions_configuration"}}'
curl   -X POST -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/environments/ -H 'Content-Type:application/json' -d '{"environment_type":{"name":"Staging"},"name":"PREPROD","restrictions": {"admin_only": true, "type": "deployment_restrictions_configuration"}}'
curl   -X POST -u $UserName:$AppPassword https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/environments/ -H 'Content-Type:application/json' -d '{"environment_type":{"name":"Production"},"name":"PROD","restrictions": {"admin_only": true, "type": "deployment_restrictions_configuration"}}'

#Branch_restriction
curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "branching_model","branch_type": "development","kind":"require_approvals_to_merge","value":1}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "branching_model","branch_type": "development","kind":"require_passing_builds_to_merge","value":1}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind":"branching_model","branch_type":"development","kind":"restrict_merges","groups": [{"slug": "'"$groupslug"'"}]}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind":"branching_model","branch_type":"development","kind":"push","groups": []}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "branching_model","branch_type": "production","kind":"require_approvals_to_merge","value":1}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "branching_model","branch_type": "production","kind":"require_passing_builds_to_merge","value":1}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind":"branching_model","branch_type":"production","kind":"restrict_merges","groups": [{"slug": "'"$groupslug"'"}]}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind":"branching_model","branch_type":"production","kind":"push","groups": []}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "glob","pattern": "release","kind":"require_approvals_to_merge","value":1}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "glob","pattern": "release","kind":"require_passing_builds_to_merge","value":1}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "glob","pattern": "release","kind":"restrict_merges","groups": [{"slug": "'"$groupslug"'"}]}'

curl -X POST -is -u $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "glob","pattern": "release","kind":"push","groups": []}'

curl -X POST -is -u  $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "glob","pattern":"bat","kind":"require_passing_builds_to_merge","value":1}'

curl -X POST -is -u  $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "glob","pattern":"bat","kind":"require_approvals_to_merge","value":1}'

curl -X POST -is -u  $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "glob","pattern":"bat","kind":"restrict_merges","groups": [{"slug": "'"$groupslug"'"}]}'

curl -X POST -is -u  $UserName:$AppPassword -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/$workspacename/$reponame/branch-restrictions -d '{"branch_match_kind": "glob","pattern":"bat","kind":"push","groups": []}'

