# How would you develop your solution further?

- make architecture more resilient and highly available, e.g. multi-region deployment, reserved concurrency for lambda
- after testing in dev, replicate to staging environment

- add unit tests and functional tests for software layer code
- add git commit hooks to run linting and formatting code to keep code clean
- add proper CI/CD pipeline to automatically run tests / linting and deploy infrastructure, e.g. github actions or jenkins. And ensure proper secret handling (using env vars where possible, and masking if printing to console)

- add proper authorisation and VPC segmenting so that api is only exposed to those intended to access it
- lockdown IAM roles to least privileges (have some \*'s sitting around)
- better error handling in the lambda function

- improve documentation, e.g. more comments describing what each part of the code does, having a proper architecture diagram
