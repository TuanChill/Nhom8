require('dotenv').config()

const formData = require('form-data');
const Mailgun = require('mailgun.js');
const mailgun = new Mailgun(formData);
const mg = mailgun.client({username: 'api', key: process.env.MAIL_KEY || 'key-yourkeyhere'});

export default {
    async sendOtp(ctx) {
        // Generate a random OTP
        const otp = Math.floor(100 + Math.random() * 900).toString();

        // Send OTP using Mailgun
        const data = {
        from: 'Daily <no-reply@luongtuan.xyz>',
        to: ctx.request.body.email,
        subject: 'Your OTP Code',
        text: `Your OTP code is ${otp}`
        };

        mg.messages.create('luongtuan.xyz', data)
          .then(msg => console.log(msg)) // logs response data
          .catch(err => console.error(err));

        // Save OTP in users_permission_user
        await strapi.query('plugin::users-permissions.user').update({
        where: { email: ctx.request.body.email },
        data: { otp }
        });

        ctx.body = {
        message: 'OTP sent successfully',
        };
    },
    async forgetPassword(ctx) {
        // Check if OTP is correct
        const user = await strapi.query('plugin::users-permissions.user').findOne({
          where: {
            email: ctx.request.body.email,
            otp: ctx.request.body.otp,
          }
        });

        if (!user) {
          ctx.throw(400, 'Invalid OTP');
        }

        // Update password
        await strapi.query('plugin::users-permissions.user').update({
          where: { email: ctx.request.body.email },
          data: { password: ctx.request.body.password }
        });

        // Clear OTP
        await strapi.query('plugin::users-permissions.user').update({
          where: { email: ctx.request.body.email },
          data: { otp: null }
        });

        ctx.body = {
          message: 'Password updated successfully'
        };
      }
};