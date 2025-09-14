SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- =========================
-- Users
-- =========================
CREATE TABLE IF NOT EXISTS users (
  id                BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_name         VARCHAR(150) NOT NULL,
  user_email        VARCHAR(320) NOT NULL,
  user_phone_number VARCHAR(40),
  user_password_hash VARCHAR(255) NOT NULL,
  user_is_admin     TINYINT(1) NOT NULL DEFAULT 0,
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_user_email (user_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Services
-- =========================
CREATE TABLE IF NOT EXISTS services (
  id                    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  svc_name              VARCHAR(255) NOT NULL,
  svc_tagline           VARCHAR(255),
  svc_overview          TEXT,
  svc_overview_secondary TEXT,
  svc_image_primary_url VARCHAR(255),
  svc_image_secondary_url VARCHAR(255),
  created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS service_sections (
  id                BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  ssec_service_id   BIGINT UNSIGNED NOT NULL,
  ssec_heading      VARCHAR(255) NOT NULL,
  ssec_body         TEXT,
  ssec_body_secondary TEXT,
  ssec_image_url    VARCHAR(255),
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_ssec_service
    FOREIGN KEY (ssec_service_id) REFERENCES services(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS service_features (
  sfeat_service_id BIGINT UNSIGNED NOT NULL,
  sfeat_feature    VARCHAR(255) NOT NULL,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (sfeat_service_id, sfeat_feature),
  CONSTRAINT fk_sfeat_service
    FOREIGN KEY (sfeat_service_id) REFERENCES services(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Team
-- =========================
CREATE TABLE IF NOT EXISTS team_members (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tm_full_name    VARCHAR(200) NOT NULL,
  tm_position     VARCHAR(200),
  tm_email        VARCHAR(320),
  tm_linkedin_url VARCHAR(2048),
  tm_bio          TEXT,
  tm_role         ENUM('executive','leadership') DEFAULT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_tm_email (tm_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS team_member_qualifications (
  id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tmq_team_member_id BIGINT UNSIGNED NOT NULL,
  tmq_text         TEXT NOT NULL,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_tmq_tm FOREIGN KEY (tmq_team_member_id) REFERENCES team_members(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS team_member_memberships (
  id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tmm_team_member_id BIGINT UNSIGNED NOT NULL,
  tmm_text         TEXT NOT NULL,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_tmm_tm FOREIGN KEY (tmm_team_member_id) REFERENCES team_members(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS team_member_publications (
  id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tmp_team_member_id BIGINT UNSIGNED NOT NULL,
  tmp_text         TEXT NOT NULL,
  tmp_kind         ENUM('pdf','link') NOT NULL,
  tmp_url          VARCHAR(2048),
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_tmp_tm FOREIGN KEY (tmp_team_member_id) REFERENCES team_members(id) ON DELETE CASCADE,
  UNIQUE KEY uniq_tmp_url (tmp_team_member_id, tmp_url)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS team_member_expertise (
  id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tmx_team_member_id BIGINT UNSIGNED NOT NULL,
  tmx_area         VARCHAR(255) NOT NULL,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_tmx_tm FOREIGN KEY (tmx_team_member_id) REFERENCES team_members(id) ON DELETE CASCADE,
  UNIQUE KEY uniq_tmx_area (tmx_team_member_id, tmx_area)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- About Page
-- =========================
CREATE TABLE IF NOT EXISTS about_page (
  id                       BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  about_heading            VARCHAR(255),
  about_subheading         VARCHAR(255),
  about_summary            TEXT,
  about_summary_secondary  TEXT,
  about_image_primary_url  VARCHAR(255),
  about_image_secondary_url VARCHAR(255),
  about_link_kind          ENUM('pdf_url','link') DEFAULT NULL,
  about_link_url           VARCHAR(2048),
  created_at               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Core Values
-- =========================
CREATE TABLE IF NOT EXISTS core_values (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  core_name     VARCHAR(255) NOT NULL,
  core_logo_url VARCHAR(255),
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_core_name (core_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS core_value_items (
  id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  cvi_core_id    BIGINT UNSIGNED NOT NULL,
  cvi_text       TEXT NOT NULL,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_cvi_core FOREIGN KEY (cvi_core_id) REFERENCES core_values(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Blog & Categories
-- =========================
CREATE TABLE IF NOT EXISTS categories (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_name   VARCHAR(150) NOT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_category_name (category_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_posts (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  blog_headline   VARCHAR(255) NOT NULL,
  blog_slug       VARCHAR(255),
  blog_body       LONGTEXT,
  blog_image_url  VARCHAR(255),
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_blog_slug (blog_slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_sections (
  id               BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bsec_blog_post_id BIGINT UNSIGNED NOT NULL,
  bsec_heading     VARCHAR(255),
  bsec_body        LONGTEXT,
  bsec_read_more_url VARCHAR(2048),
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_bsec_post FOREIGN KEY (bsec_blog_post_id) REFERENCES blog_posts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS blog_post_categories (
  bpc_blog_post_id BIGINT UNSIGNED NOT NULL,
  bpc_category_id  BIGINT UNSIGNED NOT NULL,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (bpc_blog_post_id, bpc_category_id),
  CONSTRAINT fk_bpc_post FOREIGN KEY (bpc_blog_post_id) REFERENCES blog_posts(id) ON DELETE CASCADE,
  CONSTRAINT fk_bpc_cat  FOREIGN KEY (bpc_category_id)  REFERENCES categories(id)  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Affiliates (Members & Community)
-- =========================
CREATE TABLE IF NOT EXISTS affiliates (
  id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  aff_name      VARCHAR(255) NOT NULL,
  aff_logo_url  VARCHAR(255),
  aff_link_url  VARCHAR(2048),
  aff_kind      ENUM('member','community') NOT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_aff_link (aff_link_url)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Company Locations
-- =========================
CREATE TABLE IF NOT EXISTS locations (
  id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  loc_country_name   VARCHAR(150) NOT NULL,
  loc_address        VARCHAR(500),
  loc_email          VARCHAR(320),
  loc_phone          VARCHAR(40),
  loc_google_map_url VARCHAR(2048),
  loc_image_url      VARCHAR(255),
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_loc_country (loc_country_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Insights
-- =========================
CREATE TABLE IF NOT EXISTS insights (
  id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  insight_name       VARCHAR(255) NOT NULL,  -- e.g., country/topic
  insight_image_url  VARCHAR(255),
  insight_pdf_url    VARCHAR(255),
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS insight_ip_treaties (
  iit_insight_id BIGINT UNSIGNED NOT NULL,
  iit_name       VARCHAR(255) NOT NULL,
  iit_url        VARCHAR(2048),
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (iit_insight_id, iit_name),
  CONSTRAINT fk_iit_ins FOREIGN KEY (iit_insight_id) REFERENCES insights(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS insight_fact_sheet (
  ifact_insight_id                    BIGINT UNSIGNED PRIMARY KEY,
  ifact_opposition_period             VARCHAR(255),
  ifact_protection_term               VARCHAR(255),
  ifact_vulnerability_non_use         VARCHAR(255),
  ifact_special_signs                 TEXT,
  ifact_nice_classification           VARCHAR(255),
  ifact_word_mark_search              VARCHAR(100),
  ifact_device_mark_search            VARCHAR(100),
  created_at                          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at                          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_ifact_ins FOREIGN KEY (ifact_insight_id) REFERENCES insights(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS insight_requirements_trademark (
  ireq_insight_id BIGINT UNSIGNED NOT NULL,
  ireq_role       ENUM('required_documents','process') NOT NULL,
  ireq_description TEXT,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ireq_insight_id, ireq_role),
  CONSTRAINT fk_ireq_tm_ins FOREIGN KEY (ireq_insight_id) REFERENCES insights(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS insight_requirements_patent (
  ireq_insight_id BIGINT UNSIGNED NOT NULL,
  ireq_role       ENUM('required_documents','process') NOT NULL,
  ireq_description TEXT,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ireq_insight_id, ireq_role),
  CONSTRAINT fk_ireq_pat_ins FOREIGN KEY (ireq_insight_id) REFERENCES insights(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS insight_requirements_industrial_design (
  ireq_insight_id BIGINT UNSIGNED NOT NULL,
  ireq_role       ENUM('required_documents','process') NOT NULL,
  ireq_description TEXT,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ireq_insight_id, ireq_role),
  CONSTRAINT fk_ireq_id_ins FOREIGN KEY (ireq_insight_id) REFERENCES insights(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Social Links (site-wide)
-- =========================
CREATE TABLE IF NOT EXISTS social_links (
  id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  social_linkedin_url  VARCHAR(2048),
  social_facebook_url  VARCHAR(2048),
  social_instagram_url VARCHAR(2048),
  social_x_url         VARCHAR(2048),
  social_email         VARCHAR(320),
  created_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================
-- Contact Messages
-- =========================
CREATE TABLE IF NOT EXISTS contact_messages (
  id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  contact_first_name VARCHAR(150) NOT NULL,
  contact_last_name  VARCHAR(150) NOT NULL,
  contact_phone      VARCHAR(40),
  contact_email      VARCHAR(320) NOT NULL,
  contact_subject    VARCHAR(255),
  contact_company    VARCHAR(255),
  contact_country    VARCHAR(150),
  contact_city       VARCHAR(150),
  contact_state      VARCHAR(150),
  contact_message    LONGTEXT,
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_contact_email (contact_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
