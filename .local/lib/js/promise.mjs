/**
 * Extracts values for array of settled promises
 * @param {Array<Promise>} promises - Array of settled promises
 * @returns {Promise<Array>} Array of values (undefined for failed promises)
 */
Promise.unwrap = function (promises) {
    return Promise.all(promises.map((p) => p.catch(() => undefined)));
};

/**
 * Runs asyncronous tasks with a concurrency limit
 * @param {Array<Function>} tasks - Array of functions that return promises
 * @param {number} concurrency - Max number of concurrent tasks
 * @returns {Promise<Array<Promise>>} Array of settled promises
 */
Promise.concurrentSettled = async function (tasks, concurrency) {
    const results = [];
    const executing = new Set();

    for (const task of tasks) {
        const result = Promise.resolve().then(() => task());
        results.push(result);

        const exec = result
            .then(
                () => {},
                () => {},
            )
            .finally(() => executing.delete(exec));
        executing.add(exec);

        if (executing.size >= concurrency) {
            await Promise.race(executing);
        }
    }

    await Promise.allSettled(results);

    return results;
};
