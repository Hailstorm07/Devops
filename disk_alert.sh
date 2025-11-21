#!/bin/bash

THRESHOLD=80
EMAIL="kumaraniket1188@gmail.com"

CURRENT=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')

if [ "$CURRENT" -gt "$THRESHOLD" ] ; then
    echo "Disk usage is critical: $CURRENT%"
    
    
    SUBJECT="Disk Space Alert"
    BODY="Warning: Disk usage on your EC2 instance has reached $CURRENT%. Please check the server."

    # Send Email using AWS SES
    aws ses send-email \
        --from "$EMAIL" \
        --destination "ToAddresses=$EMAIL" \
        --message "Subject={Data=$SUBJECT},Body={Text={Data=$BODY}}" \
        --region us-east-1
else
    echo "Disk usage is normal: $CURRENT%"
fi