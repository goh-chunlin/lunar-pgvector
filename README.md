
## Connect to EC2 Using SSM

Start an SSM session:
```bash
aws ssm start-session --target <SSMTestInstanceID>
```

## Connect to RDS

From within the SSM session, use psql to connect to the database:
```bash
psql -h <RDSInstanceEndpoint> -U admin -d postgres
```

## Screenshots

<img width="1840" alt="image" src="https://github.com/user-attachments/assets/8123081a-7cb0-43e0-abdf-48a8f1297294" />
