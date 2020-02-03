#!/usr/bin/env bash

BUCKET_NAME="peakbreaker-xgb-testmodels"
PROJECT_ID="amedia-playground"
FRAMEWORK="xgboost"
REGION="europe-west1"
MODEL_NAME="peakbreaker_xgbiris_test"

infra () {
  gcloud config set project $PROJECT_ID

  gsutil mb -l $REGION gs://$BUCKET_NAME
  gcloud ai-platform models create $MODEL_NAME
}

push_model(){
  VERSION_NAME=$1
  if ! [[ -e ./model.bst ]]; then
      echo "model needs to be created before running infra script"
      exit 1
  fi
  gsutil cp ./model.* gs://$BUCKET_NAME/${VERSION_NAME?Need to provide version name for model pushing}/
}

deploy_model(){
  VERSION_NAME=$1
  gcloud ai-platform versions create ${VERSION_NAME?Need to provide version name for model pushing} \
    --model  $MODEL_NAME \
    --origin gs://$BUCKET_NAME/$VERSION_NAME/ \
    --runtime-version=1.15 \
    --framework $FRAMEWORK \
    --python-version=3.7

  gcloud ai-platform versions describe $VERSION_NAME \
    --model $MODEL_NAME
}

run_predict() {
  VERSION_NAME=$1
  INPUT_FILE=$2
  gcloud ai-platform predict --model $MODEL_NAME --version \
    ${VERSION_NAME?Need to provide version name for model pushing} \
    --json-instances ${INPUT_FILE?Must provide an input file with predictors to predict on!}
}

echo -e "Source the file and run
        \t'infra' - to set up bucket and model,
        \t'push_model <version>' to push model to bucket and
        \t'deploy_model <version>' to deploy new model
        \t'run_predict <version> <input_file>' - run a prediction"

