import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '5s', target: 1 }, // 30초 동안 사용자 수를 10까지 증가
        // { duration: '1s', target: 10 },  // 1분 동안 사용자 10명 유지
        // { duration: '30s', target: 0 },  // 30초 동안 사용자 수를 0으로 감소
    ],
    vus: 10,  // 최대 가상 사용자 수
};

export default function () {
    const url = 'http://finops-test-js-327751783.ap-northeast-2.elb.amazonaws.com/members/new'; // 요청을 보낼 URL
    const vu = __VU;  // 현재 가상 사용자 번호
    const iter = __ITER;  // 현재 반복 번호
    const formData = new FormData();
    formData.append('file', fs.createReadStream(filePath))
    formData.append('name',`User${vu}-${iter}`)
    formData.append('city',`City${vu}-${iter}`)
    formData.append('street',`123 Broadway`)
    formData.append('zipcode',`12346`)
    axios.post(url, formData, {
        headers: {
          'Content-Type': 'multipart/form-data', // Content-Type 설정
        },
      })
    // const payload = JSON.stringify({
    //     name: `User${vu}-${iter}`, // 각 요청에 고유한 사용자 이름
    //     city: `City${vu}-${iter}`, // 각 요청에 고유한 도시 이름
    //     street: '123 Broadway',
    //     zipcode: '10007'
    // });

    // const params = {
    //     headers: {
    //         'Content-Type': 'application/json',
    //     },
    // };

    // const response = http.post(url, payload, params);

    // 로그 출력
    console.log(`Status: ${response.status} and response body: ${response.body}`);
    console.log(`User${vu}-${iter}`);
    check(response, {
        'is status 200 or 302': (r) => r.status === 200 || r.status === 302,
    });


    sleep(1); // 1초 대기
}
