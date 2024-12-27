export default {
    routes: [
      {
        method: 'POST',
        path: '/send-otp',
        handler: 'send-otp.sendOtp',
        config: {
          policies: [],
          middlewares: [],
        },
      },
      {
        method: 'POST',
        path: '/forgot-password',
        handler: 'send-otp.forgetPassword',
        config: {
          policies: [],
          middlewares: [],
        },
      },
    ],
  };