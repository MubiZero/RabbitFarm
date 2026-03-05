const { IdempotencyKey } = require('../models');
const ApiResponse = require('../utils/apiResponse');

/**
 * Idempotency middleware to prevent duplicate requests.
 * Uses 'Idempotency-Key' header from request.
 */
const idempotency = async (req, res, next) => {
    const key = req.headers['idempotency-key'];

    if (!key) {
        return next();
    }

    // Only apply to POST/PUT/PATCH/DELETE
    if (req.method === 'GET' || req.method === 'OPTIONS') {
        return next();
    }

    try {
        const existingKey = await IdempotencyKey.findOne({
            where: {
                key,
                user_id: req.user.id
            }
        });

        if (existingKey) {
            if (existingKey.response_status) {
                // We already have a recorded response, return it
                return res.status(existingKey.response_status).json(existingKey.response_body);
            } else {
                // Request is still processing (race condition)
                return ApiResponse.error(res, 'Request already in progress', 409);
            }
        }

        // Create a new key record
        await IdempotencyKey.create({
            key,
            user_id: req.user.id,
            request_path: req.originalUrl,
            request_method: req.method
        });

        // Intercept response to save body and status
        const originalJson = res.json;
        res.json = function (body) {
            // Don't await here to not block the response
            IdempotencyKey.update({
                response_status: res.statusCode,
                response_body: body
            }, {
                where: { key, user_id: req.user.id }
            }).catch(err => console.error('Failed to update idempotency key:', err));

            return originalJson.call(this, body);
        };

        next();
    } catch (err) {
        next(err);
    }
};

module.exports = idempotency;
