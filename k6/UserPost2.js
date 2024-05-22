import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '15m', target: 1000 }, // 30초 동안 사용자 수를 10까지 증가
        { duration: '10m', target: 1000 },
        // { duration: '5m', target: 0 },
    ],
    // vus: 10,  // 최대 가상 사용자 수
};

export default function () {
    const url = 'http://finops-test-js-327751783.ap-northeast-2.elb.amazonaws.com/members/new'; // 요청을 보낼 URL
    const vu = __VU;  // 현재 가상 사용자 번호
    const iter = __ITER;  // 현재 반복 번호
    const payload = {
        name: `User-${vu}-${iter}`, // 각 요청마다 고유한 사용자 이름
        city: `City-${vu}-${iter}`, // 각 요청마다 고유한 도시 이름
        street: '123 Broadway',
        zipcode: '10007'
    };
    const params = {
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
    };
    // 객체를 URL 인코딩된 문자열로 변환
    const formData = Object.keys(payload).map(key =>
        `${encodeURIComponent(key)}=${encodeURIComponent(payload[key])}`
    ).join('&');
    const response = http.post(url, formData, params);


    check(response, {
        'is status 200 or 302': (r) => r.status === 200 || r.status === 302, // 성공적인 응답 확인
    });


    sleep(1); // 1초 대기
}
