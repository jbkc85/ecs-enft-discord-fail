# Problem Statement

[ENFT](https://github.com/kenryu42/ethereum-nft-sales-bot) is a GitHub TypeScript library that notifies you on Discord and Twitter of a collection's NFT sales.

When running this library locally, you will receive Discord notifications. However, when you deploy to AWS ECS, you will not receive Discord notifications (without any errors).

Determine why this is, fix it, and you will earn $500 (500 USDC).

# How to run locally

`docker build -t sales-bot-test:latest .`

you will need also an `.env` file with collection's address whose sales you want to track (go to blur, sort by 15 minute volume and pick something that sells often), alchemy api key (get one [here](https://www.alchemy.com/)), and discord webhook url (create a discord channel and get the webhook url, [tutorial here](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks), and finally an etherscan api key.

now run

`docker run -it --env-file .env sales-bot-test:latest`

discord notifications should be coming in with new sales

# How to run on AWS ECS and not receive any notifications

Make sure you have terraform installed.

Hardcode the `.env` contents into `index.js` so that you have an easier life deploying this.

Build and push the new image to ECR or docker hub.

Now deploy with `terraform apply`. Go to cloudwatch and see that there are no errors, and the bot isn't posting any sales to Discord. Figure out why and fix it.
