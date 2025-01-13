
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
