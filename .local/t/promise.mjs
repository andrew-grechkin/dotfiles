import "../lib/js/promise.mjs";

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

const input = Array.from({ length: 1000 }, (_, i) => i + 1);

const print = async (num) => {
    const ms = getRandomInt(1000, 3000);
    console.log(`${num}: ${ms}`);
    if (ms > 2900) throw Error(`${num}: ${ms}`);
    await new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
    return ms;
};

const tasks = input.map((number) => () => print(number));
const settled = await Promise.concurrentSettled(tasks, 77);
console.log(settled);
const values = await Promise.unwrap(settled);
console.log(values);
