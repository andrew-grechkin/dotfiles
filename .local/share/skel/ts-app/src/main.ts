import dotenv from 'dotenv';
import mojo from '@mojojs/core';
import {minionAdminPlugin, minionPlugin} from '@minionjs/core';
import {format} from 'util';

if (!process.env.container) {
    dotenv.config();
}

const app = mojo();

process.on('SIGTERM', async () => {
    console.log('Received SIGTERM, exiting...');
    process.exit(0);
});

app.plugin(minionPlugin, {
    config: format(
        'postgres://%s:%s@%s:%s/minion',
        process.env.POSTGRES_USER,
        process.env.POSTGRES_PASSWORD,
        process.env.POSTGRES_HOST,
        process.env.POSTGRES_PORT,
    ),
});
app.plugin(minionAdminPlugin, {route: app.any('/admin')});

app.models.minion.addTask('poke_mojo', async job => {
    const res = await job.app.ua.get('https://mojolicious.org', {});
    job.app.log.debug('We have poked mojolicious.org for a visitor');
    job.finish({
        code: res.statusCode,
        message: 'We have poked mojolicious.org for a visitor',
        res: await res.text(),
        status: res.statusMessage,
    });
});

app.onStart(async app => {
    const worker = app.models.minion.worker();
    worker.status.jobs = 12;
    await worker.start();
});

app.get('/', async ctx => {
    await ctx.models.minion.enqueue('poke_mojo');
    await ctx.render({text: 'We will poke mojolicious.org for you soon.'});
});

await app.start();
