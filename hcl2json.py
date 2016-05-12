from __future__ import print_function
import json
import os
import re

def _stringify_keys(entry_dict):
    '''
    Convert hcl format to json dict, adding comments to entry lines and quoting keys as needed
    
    eg. input dict {
     default = {
       us-east-1      = "ami-aea197c1"
       sa-east-1      = "ami-fd0197e0"
      }
     }
    converts to
    {
      "default": {
        "us-east-1": "ami-aea197c1",
        "sa-east-1": "ami-fd0197e0"
      }
    }
    '''
    #entry_dict = entry_dict.lstrip('{').rstrip('}').strip('\n')
    lines = []
    in_lines = entry_dict.splitlines()
    # Does not fix end-of-line-comments
    in_lines = [x for x in in_lines if (not x.lstrip().startswith("#")) and (not x.strip() == "")]
    for i,line in enumerate(in_lines):
        # This is frail, what if = is part of tag name
        line = re.sub('\s*=',':', line)
        match = re.search('\s*(?P<key>\w|[-])+\s*', line)
        if match:
            #print("match.group('key') ", match.group('key'))
            #print("in _stringify_keys if", line)                                         
            #print("match.group(0)", match.group(0))
            # If we have something like tags { -> tags: { 
            line = re.sub(match.group(0) + '{', match.group(0) + ': ' + '{', line)
            stringified = match.group(0).strip()
            if not line.lstrip().startswith('"'):
                stringified = '"' + match.group(0).strip() + '"'
            #if ( i < len(in_lines) -1):
            #    print('in_lines[i+1] ',in_lines[i+1])
            # Add commas for list items
            if (i < len(in_lines) - 1):
                #print("SEPARATE (in_lines[i+1].find('}') == -1 ) or (in_lines[i+1].find('${') != -1) or (in_lines[i+1].find('}\"') != -1)",
                #     (in_lines[i+1].find('}') == -1 ), (in_lines[i+1].find('${') != -1), (in_lines[i+1].find('}"') != -1))
                # The next line is not a terminating dict }

                if (in_lines[i+1].find('}') == -1 ) or (in_lines[i+1].find('${') != -1) or (in_lines[i+1].find('}"') != -1):
                    if ( line.find('{') == -1) and (line.find('}') == -1):
                        # this line has no { or } in play this line
                        line = line + ','
                    else:
                        # this line has a { or } in play
                        if (line.find('${') != -1) or (line.find('}"') != -1):
                            # the { or } is for variable interpolation, not for a dict
                            line = line + ','
                        else:
                            # handle internal terminating dict not followed by final block terminanting }
                            if in_lines[i+1].find('\n}') == -1:
                                line = re.sub("\s}", "\s},",line)
            lines.append(re.sub(match.group(0), stringified, line))
        else:
            #print("NO MATCH HERE", repr(line))
            # add comment after internal dict termination }
            #if i < (len(in_lines)-1):
                #print('bools: ',(re.findall('\s}',line) != []), (i < (len(in_lines)-1)), (not re.findall('^}',in_lines[i+1])))
            if (re.findall('\s}',line) != []) and (i < (len(in_lines)-1)) and (not re.findall('^}',in_lines[i+1])):
                line = line + ','
            #print("in _stringify_keys else", line)                                         
            lines.append(line)
            #print("Regex failed on line {} of entry_dict".format(line))
    return '\n'.join(lines)

def parse_hcl_block(block):
    '''
    @param block: hashicorp language block of form entry_type "entry_class" [entry_name] entry_dict
                  where entry_name is non-unique human-friendly name only used when entry_type=resource
    @returns: dict of hcl block in json formatted dict
    '''
    parts = re.split('\s', block, maxsplit=2)
    entry = {}
    if parts[0] == 'resource':
        parts = re.split('\s', block, maxsplit=3)
        #print("parts = ",parts)
        entry['type'] = parts[0]
        entry['class'] = parts[1]
        entry['instance_name'] = parts[2]
        entry['spec'] = parts[3]
    else:
        print("parts = ",parts)
        entry['type'] = parts[0]
        entry['spec'] = parts[2]
        if entry['type'] == 'variable':
            entry['instance_name'] = parts[1]
        else:
            entry['class'] = parts[1]
    # clean up entries
    print("entry['spec'] = ", entry['spec'])
    entry['spec'] = _stringify_keys(entry['spec'])
    #print("transformed entry['spec'] = ", entry['spec'])
    entry['spec'] = json.loads(entry['spec'])
    if 'class' in entry:
        entry['class'] = entry['class'].strip('"')
    if 'instance_name' in entry:
        entry['instance_name'] = entry['instance_name'].strip('"')

    return entry
    
def get_hcl_blocks(string, entry_type):
    '''
    Parse HCL entries to json
    @param keyword: one of [resource, variable, provider, module]
    
    In order to simplify matching, we require closing '}' to occur on a newline with a blank line after.
    resource_format['resource'] = {type="resource", class, instance_name, dict, uuid=instance_id}
    resource_format['variable'] = {type="variable", instance_name, dict, uuid=trace_name_changes_here}
    resource_format['provider'] = {type="provider", class, dict, uuid=overkill}
    resource_format['module'] = {type="provider", class, dict, uuid=githash_of_checked_in_module}
    
    variable "bastion_use_elastic_ips" {default = 1}

    provider "aws" {
      region = "${var.region}"
    }

    module "security-groups" {
      source = "./terraform/aws/security_groups"
      short_name = "${var.short_name}"
      vpc_id = "${module.vpc.vpc_id}"
    }

    resource "aws_eip" "eipalloc-531cd437" {
        instance             = "i-6590e5a2"
        vpc                  = true
    }
    
    '''
    indices = []
    entry_type_idx = string.find(entry_type)
    if (entry_type == "variable") and string.splitlines()[0].rstrip().endswith("}"):
        print("SINGLE LINE VARIABLE BLOCK")
        brace_idx = string.find('}\n', entry_type_idx + 1) 
    else:
        brace_idx = string.find('\n}\n\n', entry_type_idx + 1) + 1
    #print("entry_type, entry_type_idx, brace_idx ", entry_type, entry_type_idx, brace_idx)
    if (brace_idx > 0) and (entry_type_idx >= 0):
        indices.append((entry_type_idx, brace_idx))
    while (entry_type_idx > 0):
        entry_type_idx = string.find(entry_type, max(entry_type_idx, brace_idx) + 1)
        brace_idx = string.find('\n}\n\n', entry_type_idx + 1) + 1
        if brace_idx < 0:
            brace_idx = string.find('\n}\n', entry_type_idx + 1) + 1
            print("Warning.  Found hcl block closing brace at {}  Please have one or more spaces between hcl blocks".format(
                    string[entry_type_idx:brace_idx+1]))
        if brace_idx < 0:
            brace_idx = string.find('\n}', entry_type_idx + 1) + 1
            print("Warning.  Found hcl block closing brace at {}".format(string[entry_type_idx:brace_idx+1]))
        if (brace_idx > 0) and (entry_type_idx > 0):
            print("entry_type, entry_type_idx, brace_idx ", entry_type, entry_type_idx, brace_idx)
            indices.append((entry_type_idx, brace_idx))

    #print("indices = ",indices)
    return [ string[x[0]:x[1]+1] for x in indices ]

def get_all_hcl_blocks(string):
    all_blocks = []
    for entry_type in ['variable', 'provider', 'module', 'resource']:
        all_blocks.extend(get_hcl_blocks(string, entry_type))
    return all_blocks

def parse_all_hcl_blocks(string, entry_types=None):
    all_blocks = []
    if not entry_types:
        entry_types = ['variable', 'provider', 'module', 'resource']
    
    for entry_type in entry_types:
        for block in get_hcl_blocks(string, entry_type):
            all_blocks.append(parse_hcl_block(block))
    return all_blocks 
