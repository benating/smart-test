# How would you develop your solution further?

- make architecture more resilient and highly available, e.g. multi-region deployment
- after testing in dev, replicate to staging environment

- add unit tests and functional tests for software layer code
- add git commit hooks to run linting and formatting code to keep code clean
- add proper CI/CD pipeline to automatically run tests / linting and deploy infrastructure

- add proper authorisation and VPC segmenting so that api is only exposed to those intended to access it
- lockdown IAM roles to least privileges (have some \*'s sitting around)

- improve documentation, e.g. more comments describing what each part of the code does, having a proper architecture diagram
