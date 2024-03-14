import boto3
from datetime import datetime, timezone, timedelta

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    # Get the current time
    now = datetime.now(timezone.utc)

    # Define the age limit for snapshots
    age_limit = now - timedelta(days=1)

    # List all snapshots
    snapshots = ec2.describe_snapshots(OwnerIds=['self'])['Snapshots']
    
    # List for deleted snapshot IDs
    deleted_snapshot_ids = []

    # Loop through snapshots
    for snapshot in snapshots:
        # Parse the snapshot's creation time
        creation_time = snapshot['StartTime']
        
        # Check if the snapshot is older than the age limit
        if creation_time < age_limit:
            
            # Storing the snapshot ID
            snapshot_id = snapshot['SnapshotId']
            
            # Print snapshot id that will be deleted - For logging
            print(f"Deleting snapshot:", snapshot_id)
            
            # Delete the snapshot
            ec2.delete_snapshot(SnapshotId=snapshot_id)
            
            # Append the ID of deleted snapshot to list
            deleted_snapshot_ids.append(snapshot_id)
        
        else:
            print ("No snapshots found to delete")
    
    return {
        'statusCode': 200,
        'body': {
            'message': 'Snapshots deleted successfully',
            'deletedSnapshotIds': deleted_snapshot_ids
        }
    }