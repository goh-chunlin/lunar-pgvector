
## Connect to EC2 Using SSM

Start an SSM session:
```bash
aws ssm start-session --target <SSMTestInstanceID>
```

## Install psql

```bash
sudo yum update -y

sudo yum search "postgres"

sudo yum install postgresql16
```

## Connect to RDS

From within the SSM session, use psql to connect to the database:
```bash
psql --host=<RDSInstanceEndpoint> --username=hsr_db_superuser --dbname=postgres
```

To list all tables:
```sql
\dt
```

To exit the psql command-line interface, simply type:

```sql
\q
```

This will quit the PostgreSQL session and return us to our shell or terminal.

## Screenshots

<img width="1840" alt="image" src="https://github.com/user-attachments/assets/e2848531-9e47-4142-82f4-4e264229cc55" />

<img width="1840" alt="image" src="https://github.com/user-attachments/assets/8123081a-7cb0-43e0-abdf-48a8f1297294" />

```bash
aws rds describe-db-engine-versions --default-only --engine postgres --profile chunlin_default --region ap-southeast-1
```
<img width="1837" alt="image" src="https://github.com/user-attachments/assets/9554ed44-21eb-4fe5-bb02-008346b20ca1" />