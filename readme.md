# ImageMagick for AWS Lambda

Generate a Lambda Layer with ImageMagick and some libraries

| Content | Version |
| :-- | :-- |
| ImageMagick | 7.0.9-20 |
| libbz2 | 1.0.6 |
| libjpg | 9d |
| libopenjp2 | 2.3.1 |
| libpng | 1.6.37 |
| libtiff | 4.1.0 |
| libwebp | 1.1.0 |

### Build

```bash
# download the code
$ git clone \
    --depth 1 \
    https://github.com/jeromedecoster/imagemagick-lambda-layer.git \
    /tmp/aws

# cd and build
$ cd /tmp/aws && make
```

### Already built

Check the [releases](https://github.com/jeromedecoster/imagemagick-lambda-layer/releases)

### License & Thanks

This is mainly a rewrite of the excellent [imagemagick-aws-lambda-2](https://github.com/serverlesspub/imagemagick-aws-lambda-2)