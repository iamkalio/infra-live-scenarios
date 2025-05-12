import http from 'k6/http';
import { sleep, check } from 'k6';

export const options = {
    // Key configurations for spike in this section
    stages: [
        { duration: '2m', target: 2000 }, // fast ramp-up to a high point
        // No plateau
        { duration: '1m', target: 0 }, // quick ramp-down to 0 users
    ],
};

export default () => {
    const urlRes = http.get('http://3.227.12.170:3000/');
    check(urlRes, { 'status is 200': (r) => r.status === 200 });
    sleep(1);
    // MORE STEPS
    // Add only the processes that will be on high demand
    // Step1
    // Step2
    // etc.
};