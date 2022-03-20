REPOSITORY_NAME=kwangjin-repository

# Repository의 Image 조회
echo RUN aws ecr list-images
aws ecr list-images --repository-name $REPOSITORY_NAME > list-images.json

# latest Image Id 추출
echo --- extract Latest Image ID ---
LATEST_IMAGE_ID=$(cat list-images.json | jq -c '.imageIds[] | select(.imageTag == "latest")' | jq '.imageDigest') 

echo LATEST_IMAGE_ID : $LATEST_IMAGE_ID

# wait for scan result
echo --- RUN aws ecr wait ---

aws ecr wait image-scan-complete --repository-name $REPOSITORY_NAME --image-id imageDigest=$LATEST_IMAGE_ID

echo --- COMPLETE aws ecr wait ---

# get scan result
echo --- RUN aws ecr describe-image-scan-findings ---

aws ecr describe-image-scan-findings --repository-name $REPOSITORY_NAME --image-id imageDigest=$LATEST_IMAGE_ID > describe-image.json

  
# find Severity Counts
echo --- find SeverityCounts ---

SEVERITY_COUNTS_OBJECT=$(cat describe-image.json | jq '.imageScanFinding.findingSeverityCounts')
MEDIUM_VALUE=$(echo $SEVERITY_COUNTS_OBJECT | jq '.MEDIUM // 0')
HIGH_VALUE=$(echo $SEVERITY_COUNTS_OBJECT | jq '.HIGH // 0')

echo MEDIUM_VALUE : $MEDIUM_VALUE
echo HIGH_VALUE : $HIGH_VALUE

# result Severity
echo --- result Severity ---

SEVERITY_COUNTS=$(($MEDIUM_VALUE + $HIGH_VALUE))

echo SEVERITY_COUNT : $SEVERITY_COUNTS

if [ $SEVERITY_COUNTS -eq 0 ] 
then
    echo "This stage COMPLETE"
else    
    echo "Check severity"
    exit 1
fi

