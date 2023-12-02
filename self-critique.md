# Thoughts on AWS based interview problems

## Problem #1 - AMI Breakdown Script

This problem appeared more concise than the second problem at a glance, and so I planned my high level approach but did not dig far into the details until after I had completed much of problem #2.

I made the assumption that this script would be a sort of "helper" that would be used by developers or operators to understand summary AMI information quickly.
I chose python because it's a clear and easy to work with language which can often be a little cleaner and more powerful than bash for interactions like these.
It's also so ubiquitous that we might expect a random developer to have a better likelihood of being able to pick it up and modify or maintain it than if it were written in go, C#, or java.

I saw an opportunity for synergy between the two problems because any activity involving managing VMs as IAC warrants consideration of a configuration-management tool and/or immutable infrastructure tool.
Packer has been a good choice in some of my previous work and so I decided to demonstrate its introduction for EC2 management as well as to test my problem #1 solution.


When I actually returned to problem 1 to finish the concrete implementation I found I had a few questions in my mind I hadn't originally considered -
- is this actually a helper script for developers? Or might this script be called for some sort of report generation process?
- how important would it be that the script is resilient and does not fail unattended?
- will this script be called in the middle of a complex or opaque chain of events, making it more important to test it as a unit?
- exactly how big is a "large" account with lots of instances and AMIs?

I went with a simple iteration over pages approach but decided to leave things more concise rather than trying to over-engineer my way through some of these uncertainties.


A few things which I considered adding included:
- Graceful error handling for error responses
- Retry logic for rate limiting, potentially with exponential back-off
- Batching the collected AMIs to dispatch to the describe call
- Multi-threading, where each sequential page could asynchronously de-duplicate the found AMIs into a superset which could be batch-queried in a separate thread (but would this use-case warrant that time-complexity trade-off?)
- Automated testing (But with what level of fidelity?)


## Problem #2 - Web App Infrastructure

This problem was larger in scope but a good fundamental case of working with multi-tiered networks.
I chose terraform here because I work across various cloud providers and have found it to be a good language for each of them, and often better for AWS than for others.
Cloudformation, pulumi, CDK, or crossplane might have all been reasonable choices as well (although with crossplane we'd need the assumption that we have a kubernetes cluster somewhere!)

I felt like it was worth accenting this problem with terratest for TDD and packer for immutable infrastructure management because in the IAC world the holistic approach can be a very important factor.
In my experience I have seen many more regrettable cases where corners were cut and robust solutions were deferred in favour of faster features and "temporary" toil than the opposite case where over-investment of good lifecycle practices were not worth their cost.

I considered using an atlantis instance to apply my infrastructure-live code to depict more representative process for deployment into a live environment, but I decided I didn't need to get quite that carried away. =)

I found it interesting that the problem depicted a NAT device within a security group (implying a NAT instance rather than gateway) but decided to go with a gateway instead, as they are the general recommendation from AWS today.

The depiction of the singular subnets threw me off temporarily as I tried to treat things a little too literally and to get away with a single AZ.
The RDS and LB stopped me from taking that approach! Retrospectively I have seen various diagrams in the past where a single subnet is depicted to represent a collection of subnets distributed across AZs.

I'd point out things like the fact that one should really think about alternatives to having a bastion just permanently open on 22 to the internet, and that a load balancer should probably have more than one target - but this is clearly an illustrative problem rather than an extremely life-like one, so I'll forego those comments.
