#!/usr/bin/env python3
#

import sys
import os
from string import Template
from subprocess import check_call
import yaml

args_name = sys.argv[1]
if len(sys.argv) == 3:
    only_run = sys.argv[2].split(',')
else:
    only_run = None

with open('.travis.yml', 'r') as f:
    doc = yaml.load(f, Loader=yaml.FullLoader)

print(doc)

def run_cmd(name, cmds, env):
    global only_run
    if only_run is not None and name not in only_run:
        print(f'## Skipping {name} due to only_run={only_run}')
        return

    print(f'## Running {name} ({len(cmds)} command(s)):\n## Env: {env}')
    for cmd in cmds:
        print(f'### {cmd}')
        check_call(cmd, shell=True, env=env)


def get_list (subdoc, doc, key):
    ret = subdoc.get(key, doc.get(key, list()))
    if type(ret) is str:
        return [ret]
    return ret

for ji in doc.get('jobs', dict()).get('include', list()):
    name = ji.get('name', None)
    if name is None or name != args_name:
        continue

    envs = doc.get('env', dict()).get('global', list()) + ji.get('env', list())
    env_dict = os.environ.copy()
    env_dict.update({'TRAVIS': 'True', 'PWD': os.getcwd()})
    print(envs)
    for x in envs:
        ei = x.index('=')
        n = x[:ei]
        v = x[ei+1:]
        # Expand variables and remove quotes from value
        t = Template(v)
        v = t.substitute(env_dict)
        if v[0] == '"' or v[0] == '\'':
            v = v.strip('"\'')
        env_dict[n] = v

    before_install = get_list(ji, doc, 'before_install')
    install = get_list(ji, doc, 'install')
    script = get_list(ji, doc, 'script')
    after_script = get_list(ji, doc, 'after_script')

    run_cmd('before_install', before_install, env=env_dict)
    run_cmd('install', install, env=env_dict)
    run_cmd('script', script, env=env_dict)
    run_cmd('after_script', after_script, env=env_dict)

    sys.exit(0)

print(f'## No job with name {args_name} found')
sys.exit(1)


