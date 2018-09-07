# chmod stuff
chmod 774 xnat_download.sh

docker build -t xnat_download:v0.0.1 .

# This converts the Docker image cis/bidsify to a singularity image,
# to be located in /Users/tsalo/Documents/singularity_images/
docker run --privileged -t --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /Users/michaelriedel/Desktop/singularity_images:/output \
  singularityware/docker2singularity \
  -m "/scratch" \
  xnat_download:v0.0.1
