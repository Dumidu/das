#Das

---

Place for holding GTM-attached utilities for use on /style blog, like modals, backjackers, etc.


## To Deploy to S3

### Configr:
Copy <code>config/aws-config.json.example</code> to <code>config/aws-config.json</code> and edit with necessary AWS credentials.

### Build:
Library will run tests and build before it will deploy itself.

### Deploy:
Deploy from the terminal:

    grunt deploy:production
