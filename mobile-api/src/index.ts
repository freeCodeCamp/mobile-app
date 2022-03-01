import 'dotenv/config';
import Bree from 'bree';
import express, { Request, Response } from 'express';
import path from 'path/posix';
import dbConnect from './db-connect';
import podcastRoutes from './routes';

void (async () => {
  if (process.env.NODE_ENV !== 'production') {
    // TODO: figure out why this upsets the linter - it should be fine.
    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
    const tsWorker = (await import('@breejs/ts-worker')).default;
    Bree.extend(tsWorker);
  }
})();

const app = express();
const port = 3000;
const bree = new Bree({
  root: path.join(__dirname, 'jobs'),
  defaultExtension: process.env.NODE_ENV === 'production' ? 'js' : 'ts',
  jobs: [
    {
      name: 'update-podcasts',
      timeout: 0,
      interval: '30m',
    },
  ],
});

app.get('/', (req: Request, res: Response) => {
  res.json({ msg: 'Hello World!' });
});

app.use('/podcasts', podcastRoutes);

app.listen(port, async () => {
  await dbConnect();
  console.log(`API listening on port: ${port}`);
  console.log('Initialising jobs...');
  bree.start();
});
