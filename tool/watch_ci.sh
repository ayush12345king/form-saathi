#!/usr/bin/env bash
# Waits for the GitHub build of the current commit and prints the result
# plus any error annotations. Used while developing; not part of the app.
REPO=ayush12345king/form-saathi
SHA=$(git -C "$(dirname "$0")/.." rev-parse HEAD)
sleep 15
RID=""
for i in $(seq 1 12); do
  RID=$(curl -s "https://api.github.com/repos/$REPO/actions/runs?head_sha=$SHA" | python3 -c "import sys,json;r=json.load(sys.stdin)['workflow_runs'];print(r[0]['id'] if r else '')")
  [ -n "$RID" ] && break; sleep 10
done
echo "run $RID"
for i in $(seq 1 90); do
  s=$(curl -s "https://api.github.com/repos/$REPO/actions/runs/$RID" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['status'],d['conclusion'])")
  case "$s" in completed*) echo "$s"; break;; esac
  sleep 20
done
JID=$(curl -s "https://api.github.com/repos/$REPO/actions/runs/$RID/jobs" | python3 -c "
import sys,json
j=json.load(sys.stdin)['jobs'][0]
for s in j['steps']: print('  step:',s['name'],s['conclusion'], file=sys.stderr)
print(j['id'])")
curl -s "https://api.github.com/repos/$REPO/check-runs/$JID/annotations" | python3 -c "
import sys,json
for a in json.load(sys.stdin):
  if a['annotation_level'] in ('failure','warning') and 'Node' not in a['message']: print(a['annotation_level'],a.get('title'),'|',a['message'][:500])"
