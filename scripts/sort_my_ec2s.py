
import boto3
import json

ec2 = boto3.client('ec2', region_name='us-east-2')
paginator = ec2.get_paginator('describe_instances')

ami_summary_dict = {}

for page in paginator.paginate():
 for res in page['Reservations']:
   for inst in res['Instances']:
     if inst['ImageId'] not in ami_summary_dict:
       ami_descriptions_dict = {}
       ami_descriptions_dict['InstanceIds'] = []
       ami_summary_dict[inst['ImageId']] = ami_descriptions_dict
     ami_summary_dict[inst['ImageId']]['InstanceIds'].append(inst['InstanceId'])

response = ec2.describe_images(
    ImageIds=list(ami_summary_dict.keys())
)

for image in response['Images']:
  current_ami = image['ImageId']
  if 'Description' in image:
    ami_summary_dict[current_ami]['ImageDescription'] = image['Description']
  else:
    ami_summary_dict[current_ami]['ImageDescription'] = 'null'
  if 'Name' in image:
    ami_summary_dict[current_ami]['ImageName'] = image['Name']
  else:
    ami_summary_dict[current_ami]['ImageName'] = 'null'
  if 'ImageLocation' in image:
    ami_summary_dict[current_ami]['ImageLocation'] = image['ImageLocation']
  else:
    ami_summary_dict[current_ami]['ImageLocation'] = 'null'
  if 'OwnerId' in image:
    ami_summary_dict[current_ami]['OwnerId'] = image['OwnerId']
  else:
    ami_summary_dict[current_ami]['OwnerId'] = 'null'
  # Put the instance IDs at the end to match expected format exactly.
  temp_instance_ids = ami_summary_dict[current_ami]['InstanceIds']
  del ami_summary_dict[current_ami]['InstanceIds']
  ami_summary_dict[current_ami]['InstanceIds'] = temp_instance_ids

output_string = json.dumps(ami_summary_dict, indent=4)
print(output_string.replace('"null"', 'null'))
