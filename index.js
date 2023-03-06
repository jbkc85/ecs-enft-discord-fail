import 'dotenv/config';
import { Auth, ENFT } from 'enft';
import 'dotenv/config';
import * as dotenv from 'dotenv';
dotenv.config();
const SECRETS = [
  'CONTRACT_ADDRESS',
  'ALCHEMY_API_KEY',
  'ETHERSCAN_API_KEY',
  'WEBHOOK_URL',
];

const NO_ENV_FILE = process.env[SECRETS[0]] === undefined;

async function main() {
  const _env = {};
  function getSecretsFromEnvFile() {
    for (const secret of SECRETS) {
      _env[secret] = process.env[secret];
    }
  }
  await (async () => {
    if (NO_ENV_FILE) {
      // console.log('no .env file found');
      // await getSecretsFromKms();
    } else {
      // console.log('.env file found');
      getSecretsFromEnvFile();
    }
  })();
  const CONTRACT_ADDRESS = _env['CONTRACT_ADDRESS']
    ? _env['CONTRACT_ADDRESS'].toLowerCase()
    : '';
  const ALCHEMY_API_KEY = _env['ALCHEMY_API_KEY'] || '';
  const ETHERSCAN_API_KEY = _env['ETHERSCAN_API_KEY'] || '';
  // Discord webhook settings
  const WEBHOOK = _env['WEBHOOK_URL'] || '';

  const auth = new Auth({
    alchemy: {
      apiKey: ALCHEMY_API_KEY,
    },
  });
  const enft = new ENFT(auth);
  enft.onItemSold(
    {
      contractAddress: CONTRACT_ADDRESS,
      etherscanApiKey: ETHERSCAN_API_KEY,
      discordWebhook: WEBHOOK,
    }
  );
}

main();
