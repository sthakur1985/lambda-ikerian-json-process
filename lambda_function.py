import json
import boto3
import logging
from urllib.parse import unquote_plus

# try to import layer stuff
try:
    import requests
    import pandas as pd
    import numpy as np
    LAYER_AVAILABLE = True
except ImportError:
    LAYER_AVAILABLE = False

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    """Process JSON files from S3 - extract patient info"""
    
    try:
        # get the file info from s3 event
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = unquote_plus(event['Records'][0]['s3']['object']['key'])
        
        logger.info(f"Processing {key} from {bucket}")
        logger.info(f"Layer stuff available: {LAYER_AVAILABLE}")
        
        # grab the file from s3
        response = s3_client.get_object(Bucket=bucket, Key=key)
        file_content = response['Body'].read().decode('utf-8')
        
        # parse json
        data = json.loads(file_content)
        logger.info(f"Got {len(data)} records")
        
        # use pandas if we have it
        if LAYER_AVAILABLE:
            df = pd.DataFrame(data)
            logger.info(f"DataFrame shape: {df.shape}")
            data = df.to_dict('records')
        
        # Extract patient_id and patient_name fields
        processed_data = []
        for record in data:
            if 'patient_id' in record and 'patient_name' in record:
                processed_record = {
                    'patient_id': record['patient_id'],
                    'patient_name': record['patient_name']
                }
                processed_data.append(processed_record)
        
        logger.info(f"Extracted {len(processed_data)} patient records")
        
        # Define processed bucket name (will be created by Terraform)
        processed_bucket = bucket.replace('-raw-', '-processed-')
        
        # Create processed filename
        processed_key = f"processed_{key}"
        
        # Upload processed data to processed bucket
        s3_client.put_object(
            Bucket=processed_bucket,
            Key=processed_key,
            Body=json.dumps(processed_data, indent=2),
            ContentType='application/json'
        )
        
        logger.info(f"Successfully uploaded processed data to {processed_bucket}/{processed_key}")
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Data processed successfully',
                'processed_records': len(processed_data),
                'output_location': f"{processed_bucket}/{processed_key}"
            })
        }
        
    except Exception as e:
        logger.error(f"Error processing data: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }