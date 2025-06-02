import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    vus: 3, // Key for Smoke test. Keep it at 2, 3, max 5 VUs
    duration: '1m', // This can be shorter or just a few iterations
};

export default () => {
    // Replace 'http://YOUR_EC2_PUBLIC_IP:3000/' with your actual public IP and port
    const urlRes = http.get('http://YOUR_EC2_PUBLIC_IP:3000/');
    check(urlRes, { 'status is 200': (r) => r.status === 200 });
    sleep(1);
};