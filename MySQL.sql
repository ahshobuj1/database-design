CREATE TABLE `users` (
  `id` UUID PRIMARY KEY,
  `first_name` String,
  `last_name` String,
  `email` String UNIQUE,
  `password` String,
  `role` ENUM ('SUPER_ADMIN', 'DJ'),
  `profile_img` String,
  `is_verified` Boolean,
  `otp` String,
  `otp_expiry` Timestamp,
  `created_at` Timestamp,
  `updated_at` Timestamp
);

CREATE TABLE `themes` (
  `id` Int PRIMARY KEY,
  `name` String,
  `slug` String,
  `preview_image_url` String,
  `default_config` JSONB,
  `created_at` Timestamp,
  `updated_at` Timestamp
);

CREATE TABLE `tenants` (
  `id` UUID PRIMARY KEY,
  `user_id` UUID UNIQUE,
  `subdomain` String UNIQUE,
  `stage_name` String,
  `country` String,
  `city` String,
  `genres` JSONB,
  `theme_id` Int,
  `logo_url` String,
  `bio` Text,
  `timezone` String,
  `is_active` Boolean,
  `social_links` JSONB,
  `config` JSONB,
  `created_at` Timestamp,
  `updated_at` Timestamp
);

CREATE TABLE `subscription_plans` (
  `id` Int PRIMARY KEY,
  `name` String,
  `price_monthly` Decimal,
  `price_annually` Decimal,
  `stripe_monthly_price_id` String,
  `stripe_annual_price_id` String,
  `discount_percentage` Int,
  `features` JSONB,
  `created_at` Timestamp,
  `updated_at` Timestamp
);

CREATE TABLE `subscriptions` (
  `id` UUID PRIMARY KEY,
  `user_id` UUID,
  `plan_id` Int,
  `stripe_sub_id` String,
  `status` ENUM ('active', 'past_due', 'canceled'),
  `period_end` Timestamp,
  `created_at` Timestamp,
  `updated_at` Timestamp
);

CREATE TABLE `mix_tapes` (
  `id` UUID PRIMARY KEY,
  `tenant_id` UUID,
  `title` String,
  `audio_url` String,
  `cover_url` String,
  `order` Int,
  `created_at` Timestamp,
  `updated_at` Timestamp
);

CREATE TABLE `events` (
  `id` UUID PRIMARY KEY,
  `tenant_id` UUID,
  `title` String,
  `description` Text,
  `event_date` Date,
  `venue_name` String,
  `venue_address` String,
  `capacity` Int,
  `price` Decimal,
  `status` ENUM ('upcoming', 'completed', 'cancelled'),
  `created_at` Timestamp,
  `updated_at` Timestamp
);

CREATE TABLE `bookings` (
  `id` UUID PRIMARY KEY,
  `tenant_id` UUID,
  `client_name` String,
  `client_email` String,
  `event_type` String,
  `event_details` Text,
  `status` ENUM ('pending', 'accepted', 'completed'),
  `total_amount` Decimal,
  `created_at` Timestamp,
  `updated_at` Timestamp
);

CREATE TABLE `invoices` (
  `id` UUID PRIMARY KEY,
  `tenant_id` UUID,
  `booking_id` UUID UNIQUE,
  `user_id` UUID,
  `amount` Decimal,
  `type` ENUM ('SUBSCRIPTION', 'BOOKING'),
  `method` ENUM ('STRIPE', 'CASH'),
  `status` ENUM ('paid', 'unpaid'),
  `created_at` Timestamp,
  `updated_at` Timestamp
);

CREATE TABLE `webhook_events` (
  `id` UUID PRIMARY KEY,
  `stripe_event_id` String,
  `type` String,
  `status` String,
  `created_at` Timestamp
);

CREATE TABLE `audit_logs` (
  `id` UUID PRIMARY KEY,
  `user_id` UUID,
  `action` String,
  `metadata` JSONB,
  `ip_address` String,
  `created_at` Timestamp
);

CREATE TABLE `support_tickets` (
  `id` UUID PRIMARY KEY,
  `user_id` UUID,
  `full_name` String,
  `email` String,
  `subject` String,
  `issue` Text,
  `status` ENUM ('open', 'in_progress', 'resolved'),
  `created_at` Timestamp
);

CREATE TABLE `notifications` (
  `id` UUID PRIMARY KEY,
  `user_id` UUID,
  `title` String,
  `message` Text,
  `type` ENUM ('booking_request', 'payment', 'system'),
  `is_read` Boolean,
  `created_at` Timestamp
);

CREATE TABLE `landing_page_heroes` (
  `id` Int PRIMARY KEY,
  `title` String,
  `description` Text,
  `image_url` String,
  `is_active` Boolean
);

CREATE TABLE `landing_page_steps` (
  `id` Int PRIMARY KEY,
  `title` String,
  `description` Text,
  `image_url` String,
  `order` Int
);

CREATE TABLE `landing_page_services` (
  `id` Int PRIMARY KEY,
  `title` String,
  `description` Text,
  `image_url` String,
  `order` Int
);

CREATE TABLE `landing_page_faqs` (
  `id` Int PRIMARY KEY,
  `question` String,
  `answer` Text,
  `order` Int
);

CREATE TABLE `landing_page_marquees` (
  `id` Int PRIMARY KEY,
  `image_url` String,
  `order` Int
);

ALTER TABLE `tenants` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `tenants` ADD FOREIGN KEY (`theme_id`) REFERENCES `themes` (`id`);

ALTER TABLE `mix_tapes` ADD FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`);

ALTER TABLE `events` ADD FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`);

ALTER TABLE `bookings` ADD FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`);

ALTER TABLE `invoices` ADD FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`);

ALTER TABLE `subscriptions` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `subscriptions` ADD FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`id`);

ALTER TABLE `invoices` ADD FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`);

ALTER TABLE `invoices` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `audit_logs` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `support_tickets` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `notifications` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
