#!/bin/bash -x
JENKINS_HOST=admin:admin@localhost:8080

curl -O "http://$JENKINS_HOST/jnlpJars/jenkins-cli.jar"
UPDATE_LIST=$( java -jar jenkins-cli.jar -s http://$JENKINS_HOST/ list-plugins | grep -e ')$' | awk '{ print $1 }' );

if [ -n "${UPDATE_LIST}" ]; then
    echo Updating Jenkins Plugins: "${UPDATE_LIST};"
    java -jar jenkins-cli.jar -s "http://$JENKINS_HOST/" install-plugin "${UPDATE_LIST}";
fi
rm jenkins-cli.jar

curl -sSL "http://$JENKINS_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/' > /tmp/jenkins_plugins.txt
sort -o /tmp/sorted_jenkins_plugins.txt /tmp/jenkins_plugins.txt
sed -i '1s/^/# See https:\/\/github.com\/jenkinsci\/docker#usage-1\n/' /tmp/sorted_jenkins_plugins.txt
diff -u ./plugins.txt /tmp/sorted_jenkins_plugins.txt > /tmp/jenkins_plugins.diff
if [ -s /tmp/jenkins_plugins.diff ]; then
    echo "Plugins have changed, updating plugins.txt"
    echo "$GITHUB_CREDENTIALS_PSW" | gh auth login --with-token
    cp /tmp/sorted_jenkins_plugins.txt ./plugins.txt
    git add ./plugins.txt
    git add ./update-plugins.sh

    branch_name=$GIT_BRANCH
    echo "Working on branch $branch_name for repo $GIT_URL"
    new_branch_name="update-$branch_name/"$(sha1sum /tmp/jenkins_plugins.diff | cut -d " " -f1)
    git config --global user.email "116569+gounthar@users.noreply.github.com"
    git config --global user.name "$GITHUB_CREDENTIALS_USR"

    git switch -c "${new_branch_name}" -m
    git commit -m "Update plugins.txt for ${UPDATE_LIST} plugins"

    git push --set-upstream https://"$GITHUB_CREDENTIALS_USR":"$GITHUB_CREDENTIALS_PSW"@github.com/ash-sxn/GSoC-2023-docker-based-quickstart.git "${new_branch_name}"
    gh pr create -B "$branch_name" -t "Update plugins.txt" -b "Update plugins.txt" --head "${new_branch_name}" --base "$branch_name"
    git switch "${branch_name}"
else
    echo "Plugins have not changed"
fi

