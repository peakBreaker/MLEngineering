#/usr/bin/env bash

FRAMEWORK="xgboost"

# Apparently we need to remove all .pyc files un the gcloud sdk ml engine folder - cause hey thats fun
find "/home/peakbreaker/Downloads/google-cloud-sdk/lib/googlecloudsdk/command_lib/ml_engine/" -name '*.pyc' -delete

# Test inference on the model
gcloud ai-platform local predict --model-dir=$(pwd)/ \
  --json-instances=$(pwd)/input.json \
  --framework=xgboost \
  --verbosity=debug
# gcloud ai-platform local predict --model-dir gs://$BUCKET_NAME/ \
  # --json-instances input.json \
  # --framework $FRAMEWORK
