/*
// REQUEST
{
  "to": "recipient@example.com",
  "subject": "Test Email Subject",
  "text": "Plain text content of the email",
  "html": "<p>HTML content of the email</p>",
  "from": "sender@example.com",
  "template": "welcome_email"
}

// RESPONSE (Success)
{
  "success": true,
  "data": {
    "messageId": "msg_1234567890",
    "accepted": ["recipient@example.com"],
    "rejected": []
  }
}

// RESPONSE (Error)
{
  "success": false,
  "error": "Failed to send email: Invalid recipient address"
}
*/

import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import cors from "cors";
import * as nodemailer from "nodemailer";
const corsHandler = cors({
  origin: true,
  methods: ["GET", "POST", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,
});

export const sendEmail = onRequest({
  invoker: "public",
}, async (request, response) => {
  corsHandler(request, response, async () => {
    try {
      const smtpHost = process.env.SMTP_HOST;
      const smtpPort = parseInt(process.env.SMTP_PORT || "465");
      const smtpUser = process.env.SMTP_USERNAME;
      const smtpPass = process.env.SMTP_PASSWORD;
      const smtpEncryption = (process.env.SMTP_ENCRYPTION ||
        "SSL").toUpperCase();
      const smtpFrom = process.env.SMTP_FROM_EMAIL ||
        smtpUser;
      let secure = false;
      let requireTLS = false;
      if (smtpEncryption === "SSL") {
        secure = true;
        requireTLS = false;
      } else if (smtpEncryption === "STARTTLS") {
        secure = false;
        requireTLS = true;
      }
      const SMTP_CONFIG: any = {
        host: smtpHost,
        port: smtpPort,
        secure,
        auth: {
          user: smtpUser,
          pass: smtpPass,
        },
      };
      if (requireTLS) {
        SMTP_CONFIG.requireTLS = true;
      }

      logger.info("All ENV vars:", Object.keys(process.env)
        .filter((key) => key.includes("SMTP") || key.includes("APP_")));
      logger.info("All ENV vars with values:", JSON.stringify(
        Object.fromEntries(
          Object.entries(process.env)
            .filter(([key]) => key.includes("SMTP") || key.includes("APP_"))
        ), null, 2
      ));
      if (request.method !== "POST") {
        response.status(405).send("Method Not Allowed");
        return;
      }
      const {toEmail, message, emailSubject} = request.body;
      if (!toEmail || !message) {
        response.status(400).json({
          error: "Both toEmail and message are required",
        });
        return;
      }
      const transporter = nodemailer.createTransport(SMTP_CONFIG);
      const mailOptions = {
        from: smtpFrom,
        to: toEmail,
        subject: emailSubject,
        text: message,
        html: `<p>${message}</p>`,
      };
      const info = await transporter.sendMail(mailOptions);
      logger.info(`Email sent to ${toEmail}`, {messageId: info.messageId});
      response.json({
        success: true,
        messageId: info.messageId,
      });
    } catch (error) {
      logger.error("Email sending failed:", error);
      response.status(500).json({
        success: false,
        error: "Failed to send activation email",
        details: error instanceof Error ? error.message : String(error),
      });
    }
  });
});
