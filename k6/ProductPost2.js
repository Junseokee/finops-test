import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '5m', target: 5000 }, // 30초 동안 사용자 수를 10까지 증가
        { duration: '30s', target: 5000 },  // 1분 동안 사용자 10명 유지
        // { duration: '30s', target: 0 },  // 30초 동안 사용자 수를 0으로 감소
    ],
    // vus: 200,  // 최대 가상 사용자 수
};

export default function () {
    const url = 'http://finops-test-js-327751783.ap-northeast-2.elb.amazonaws.com/items/new'; // 요청을 보낼 URL
    const vu = __VU;  // 현재 가상 사용자 번호
    const iter = __ITER;  // 현재 반복 번호
    const payload = {
        name: `Product-${vu}-${iter}`, // 각 요청마다 고유한 사용자 이름
        price: parseInt('100000'), // 가격을 정수로 변환
        stockQuantity: parseInt('10000000'), // 재고 수량을 정수로 변환
        author: `Author ${iter}`, // 저자 이름
        isbn: `isbn ${iter}` // ISBN 번호
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
