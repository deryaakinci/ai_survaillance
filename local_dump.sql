--
-- PostgreSQL database dump
--

\restrict OipRh33z5CjMH3HaBO3cxB3VpymJj7kbcOCzeV5D1znnOifIzuOqAf3kcuyp3kk

-- Dumped from database version 16.13 (Homebrew)
-- Dumped by pg_dump version 16.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alerts (
    id character varying NOT NULL,
    user_id character varying NOT NULL,
    event_id character varying,
    audio_label character varying,
    visual_label character varying,
    severity character varying,
    zone character varying,
    snapshot_url character varying,
    audio_clip_url character varying,
    "timestamp" timestamp without time zone,
    video_clip_url character varying
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id character varying NOT NULL,
    user_id character varying NOT NULL,
    "timestamp" timestamp without time zone,
    audio_label character varying,
    visual_label character varying,
    fusion_score double precision,
    alert_fired boolean,
    zone character varying,
    audio_confidence double precision DEFAULT 0.0,
    visual_confidence double precision DEFAULT 0.0,
    severity character varying DEFAULT 'low'::character varying,
    total_events_in_chunk integer DEFAULT 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id character varying NOT NULL,
    name character varying,
    email character varying,
    password_hash character varying,
    created_at timestamp without time zone
);


--
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alerts (id, user_id, event_id, audio_label, visual_label, severity, zone, snapshot_url, audio_clip_url, "timestamp", video_clip_url) FROM stdin;
ff116818-7cc7-4fe3-a586-93ed3d8b1f34	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	intruder_detected	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777967911667.jpg	\N	2026-05-05 07:58:31.676438	\N
112e902b-206c-4e31-a5bd-137f9f978412	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	intruder_detected	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777967911667.jpg	\N	2026-05-05 07:58:31.676516	\N
47841e25-d933-48f2-a7a3-ce634d5c9d8e	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777967911743.jpg	\N	2026-05-05 07:58:31.747429	\N
f1c1c045-2f7f-478f-8df9-dc0c043c48db	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777967911743.jpg	\N	2026-05-05 07:58:31.747506	\N
d1b1da7c-a826-403a-abbb-9b0d8aacb83a	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	car_crash	normal	medium	Demo Camera	/static/snapshots/snap_1777967911820.jpg	\N	2026-05-05 07:58:31.824297	\N
c8d62994-c7fa-4a40-82b6-7aaea862fe68	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	car_crash	normal	medium	Demo Camera	/static/snapshots/snap_1777967911820.jpg	\N	2026-05-05 07:58:31.824373	\N
5144cb00-9da1-40b4-a8a0-61373fb3d6d2	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777967912308.jpg	\N	2026-05-05 07:58:32.312937	\N
891b79dd-20a2-436d-af26-a8e8badf2c37	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777967912308.jpg	\N	2026-05-05 07:58:32.313009	\N
37bfeaa5-9b0d-4113-a07d-9629934dc3d0	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	forced_entry	high	Demo Camera	/static/snapshots/snap_1777967913143.jpg	\N	2026-05-05 07:58:33.147873	\N
4cb6fc96-154a-4bec-8519-115a1d154107	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	forced_entry	high	Demo Camera	/static/snapshots/snap_1777967913143.jpg	\N	2026-05-05 07:58:33.147939	\N
502e968d-64f7-48a4-a8b0-8677a4551924	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777967913418.jpg	\N	2026-05-05 07:58:33.426909	\N
3cefed5d-3354-4ed9-a826-dabce8329d77	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777967913418.jpg	\N	2026-05-05 07:58:33.426969	\N
8aaecda5-ea31-4023-b532-1a6d9aaafa12	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777967913993.jpg	\N	2026-05-05 07:58:33.996899	\N
0acde7f6-c6ec-40eb-9c18-063cccad8d8b	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777967913993.jpg	\N	2026-05-05 07:58:33.996976	\N
75112744-6d27-4432-966d-0a1a383dafb8	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777967914204.jpg	\N	2026-05-05 07:58:34.207799	\N
7e0c1a24-6b68-441e-82d6-7b20bfd00268	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777967914204.jpg	\N	2026-05-05 07:58:34.207854	\N
9cc5b69a-615e-4b34-b8d6-0ca8152b0f44	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777967914669.jpg	\N	2026-05-05 07:58:34.673003	\N
6d263be4-d360-4f22-8d69-34575f3e66bc	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777967914669.jpg	\N	2026-05-05 07:58:34.673071	\N
a470de22-91ea-4c7c-a060-96568dd7f606	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	threatening_voice	normal	high	Demo Camera	/static/snapshots/snap_1777968137916.jpg	\N	2026-05-05 08:02:17.92409	\N
16fca421-e504-451c-a6d8-03ca46d2e26f	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	threatening_voice	normal	high	Demo Camera	/static/snapshots/snap_1777968137916.jpg	\N	2026-05-05 08:02:17.924166	\N
15ff6b39-1fc7-41cf-b06d-3fbc52c745c5	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777968138946.jpg	\N	2026-05-05 08:02:18.952547	\N
f1b3220c-ad08-42b8-95d5-ab962faf0122	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777968138946.jpg	\N	2026-05-05 08:02:18.952611	\N
e8555fc1-b009-4aac-83a2-808c8bd39410	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	threatening_voice	normal	high	Demo Camera	/static/snapshots/snap_1777968294678.jpg	\N	2026-05-05 08:04:54.685996	\N
3dedea7a-999a-4151-9a59-ad11ee3ad266	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	threatening_voice	normal	high	Demo Camera	/static/snapshots/snap_1777968294678.jpg	\N	2026-05-05 08:04:54.686057	\N
3c3389c7-e238-430f-8d66-fdbfbf8bccfd	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777968295753.jpg	\N	2026-05-05 08:04:55.76028	\N
c28825b0-ce70-480e-b817-73c54e509cee	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777968295753.jpg	\N	2026-05-05 08:04:55.760346	\N
08a624df-b4f3-4033-834e-aa128584d40d	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777968821478.jpg	\N	2026-05-05 08:13:41.487943	\N
f43bf9a1-465d-47ec-9106-38a670f7049b	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777968821478.jpg	\N	2026-05-05 08:13:41.488012	\N
ebd238dc-f750-4d97-902c-9941dd6151d4	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777968821715.jpg	\N	2026-05-05 08:13:41.721959	\N
5c3c4d46-b479-4bd3-8ec3-3d5486c314b1	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777968821715.jpg	\N	2026-05-05 08:13:41.722016	\N
a2b9c5ab-9ad6-45f9-a67b-fbb189be0fc1	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	forced_entry	normal	high	Demo Camera	/static/snapshots/snap_1777968949545.jpg	\N	2026-05-05 08:15:49.555271	\N
7a510ef2-7d2b-42c2-9e7a-42a2cab74304	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	forced_entry	normal	high	Demo Camera	/static/snapshots/snap_1777968949545.jpg	\N	2026-05-05 08:15:49.555329	\N
ffa9eaf7-b2fe-49ed-8ef7-2efd881d5394	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777969083497.jpg	\N	2026-05-05 08:18:03.501176	\N
f81c9ad6-7d0d-4724-b3fc-1ba4d7a9258b	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777969083497.jpg	\N	2026-05-05 08:18:03.501233	\N
ab0faa34-8715-4b0b-aa8d-68bf196eb3d2	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777969083556.jpg	\N	2026-05-05 08:18:03.56015	\N
97f8e08c-a067-4f92-9a25-eb033f852040	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777969083556.jpg	\N	2026-05-05 08:18:03.560202	\N
2982ed8a-437d-451c-9f14-a8ec6744a8d9	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777969366065.jpg	\N	2026-05-05 08:22:46.071115	\N
be78cfbb-a46d-4e64-bfaa-9d982de3f085	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777969366065.jpg	\N	2026-05-05 08:22:46.071168	\N
fac4ba8b-f263-4185-bfea-de8eebc9c7d6	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777969383763.jpg	\N	2026-05-05 08:23:03.766819	\N
6c47692c-e4d3-42cf-86fc-22f1a1900dc5	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777969383763.jpg	\N	2026-05-05 08:23:03.766874	\N
57191419-67e2-4810-a60e-2986c2b910ef	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777969384024.jpg	\N	2026-05-05 08:23:04.028355	\N
91de5024-1416-4121-86c4-f61be13d48dd	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777969384024.jpg	\N	2026-05-05 08:23:04.028409	\N
31fd9d29-6767-4c8a-8610-108e595ecda5	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777969394539.jpg	\N	2026-05-05 08:23:14.542702	\N
c9151369-c9f9-4974-84ea-88549d75609a	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777969394539.jpg	\N	2026-05-05 08:23:14.542762	\N
951df28e-c6a7-4b5e-80c2-f8aebda7e56b	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777969583673.jpg	\N	2026-05-05 08:26:23.677047	\N
506a984d-1bb5-43c4-89ab-6a1df77f8eec	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777969583673.jpg	\N	2026-05-05 08:26:23.677103	\N
97a1efdb-c9fb-41a6-8934-e0967b3f9f28	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777969585628.jpg	\N	2026-05-05 08:26:25.632538	\N
863bb02c-85ad-43f0-8bc6-faf2c09d1403	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777969585628.jpg	\N	2026-05-05 08:26:25.632591	\N
763dba4d-b416-4163-902d-63550e1aa295	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	assault	high	Demo Camera	/static/snapshots/snap_1777969587336.jpg	\N	2026-05-05 08:26:27.340305	\N
0bdbb7eb-2669-4fcf-8373-dddbfbfc2f07	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	assault	high	Demo Camera	/static/snapshots/snap_1777969587336.jpg	\N	2026-05-05 08:26:27.340359	\N
925389e6-e6d5-4369-87bd-473696aa15f3	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777969587576.jpg	\N	2026-05-05 08:26:27.580108	\N
f28a738b-cc9e-4007-acb7-61f23d166cda	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777969587576.jpg	\N	2026-05-05 08:26:27.580159	\N
7e015183-be3e-41d0-a424-fd59a6e2ca1a	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777969594368.jpg	\N	2026-05-05 08:26:34.371926	\N
d9214f40-8205-4c95-8def-9cbac7cde4db	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777969594368.jpg	\N	2026-05-05 08:26:34.371977	\N
5d74844c-9a74-4645-a58d-cd93788649c5	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777969607287.jpg	\N	2026-05-05 08:26:47.291664	\N
9aecf1ff-a08a-4cb2-8fb3-8189ffa721fc	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777969607287.jpg	\N	2026-05-05 08:26:47.291715	\N
a1b1867b-05a1-44fe-b767-d771182fcf96	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777969619169.jpg	\N	2026-05-05 08:26:59.176546	\N
2414212a-3f08-473d-b0f1-298a32f0d2db	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777969619169.jpg	\N	2026-05-05 08:26:59.176622	\N
b650a680-0211-4484-bdaa-34bc9a0a30ad	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777969384255.jpg	\N	2026-05-05 08:23:04.259295	\N
c32cdac8-dd90-4872-97c9-d37b8c7a6151	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777969384255.jpg	\N	2026-05-05 08:23:04.259349	\N
057d8aaf-b7ba-4064-b3be-23808182b3ce	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777969387206.jpg	\N	2026-05-05 08:23:07.209772	\N
add06d3a-6dd0-4f7d-bb3a-3217f9ce438b	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777969387206.jpg	\N	2026-05-05 08:23:07.209828	\N
e6f2ac92-7d96-4db5-b5de-70ba955c387d	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	forced_entry	high	Demo Camera	/static/snapshots/snap_1777969392098.jpg	\N	2026-05-05 08:23:12.102171	\N
4cbad0b0-a93a-422c-9922-ec332a07674e	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	forced_entry	high	Demo Camera	/static/snapshots/snap_1777969392098.jpg	\N	2026-05-05 08:23:12.102235	\N
450b50c2-2c84-4ebb-ae27-7dec0accc799	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777969583921.jpg	\N	2026-05-05 08:26:23.924967	\N
ac3ab2fe-a460-4b09-ab8b-6d9e688f9f6a	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777969583921.jpg	\N	2026-05-05 08:26:23.925019	\N
787699dc-b620-404d-bb0f-93cfc372e008	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	abuse	abuse	high	Demo Camera	/static/snapshots/snap_1777969606378.jpg	\N	2026-05-05 08:26:46.382924	\N
93d2604e-cb4e-4ff0-a68d-610ddafca87e	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	abuse	abuse	high	Demo Camera	/static/snapshots/snap_1777969606378.jpg	\N	2026-05-05 08:26:46.382984	\N
d1651261-5c80-4a48-8999-571f0c92efe0	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777969584155.jpg	\N	2026-05-05 08:26:24.159223	\N
03990897-5614-4e43-bf53-bd85fd565c80	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777969584155.jpg	\N	2026-05-05 08:26:24.159277	\N
afdffa85-069e-458a-99a6-c3c59dcad1ed	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	forced_entry	high	Demo Camera	/static/snapshots/snap_1777969588068.jpg	\N	2026-05-05 08:26:28.072414	\N
f8a9e231-0255-460d-80f7-d84fc61ca146	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	forced_entry	high	Demo Camera	/static/snapshots/snap_1777969588068.jpg	\N	2026-05-05 08:26:28.072474	\N
a078160b-94d8-4702-be71-59f932dc58a4	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777969606714.jpg	\N	2026-05-05 08:26:46.718137	\N
24b6fe61-295d-4a3b-8583-3f458ad80fea	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777969606714.jpg	\N	2026-05-05 08:26:46.718191	\N
ac79fa0b-00a7-4aaf-8f9b-dbd64d09ddab	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777969607921.jpg	\N	2026-05-05 08:26:47.925689	\N
adc79693-f399-4aa2-8c6d-d96213f9abc6	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777969607921.jpg	\N	2026-05-05 08:26:47.925743	\N
e7612a08-111d-4593-ac3b-b5239cf4f681	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	gunshot	normal	high	Demo Camera	/static/snapshots/snap_1777970287873.jpg	\N	2026-05-05 08:38:07.880394	\N
33be389b-d5ce-4442-b455-fc4534e5a97c	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	gunshot	normal	high	Demo Camera	/static/snapshots/snap_1777970287873.jpg	\N	2026-05-05 08:38:07.880454	\N
1cb94e27-6a37-4fbc-aaec-a9bad77b37cb	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777970289087.jpg	\N	2026-05-05 08:38:09.09458	\N
871b1a8b-bac1-49c1-80f8-9ffe332e1273	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777970289087.jpg	\N	2026-05-05 08:38:09.094641	\N
f7107614-9b65-4e99-81dc-1584e3dfbeab	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	scream	normal	high	Demo Camera	/static/snapshots/snap_1777970290898.jpg	\N	2026-05-05 08:38:10.90558	\N
2bbf2421-16ee-4a3c-8300-76d31b1b3483	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	scream	normal	high	Demo Camera	/static/snapshots/snap_1777970290898.jpg	\N	2026-05-05 08:38:10.905647	\N
57904e4f-63b0-4bcb-be7b-b59c886488b0	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	fight_sounds	normal	high	Demo Camera	/static/snapshots/snap_1777970293424.jpg	\N	2026-05-05 08:38:13.431616	\N
b1c2cd9d-a312-4a65-b863-5222453648af	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	fight_sounds	normal	high	Demo Camera	/static/snapshots/snap_1777970293424.jpg	\N	2026-05-05 08:38:13.431674	\N
d017f286-f7f9-4b24-b98a-78e5d9a8edff	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	abuse	abuse	high	Demo Camera	/static/snapshots/snap_1777970301994.jpg	\N	2026-05-05 08:38:21.998813	\N
8764ff31-e385-47f6-b13f-fa7fcbdc4f59	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	abuse	abuse	high	Demo Camera	/static/snapshots/snap_1777970301994.jpg	\N	2026-05-05 08:38:21.998868	\N
fcc4b7b9-9eba-4310-8450-512cae938270	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777970302326.jpg	\N	2026-05-05 08:38:22.330439	\N
7a533840-05f9-496b-b946-0e8f1517f8be	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777970302326.jpg	\N	2026-05-05 08:38:22.33049	\N
fbe09de2-b32a-4683-b431-a16ba571623a	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777970302919.jpg	\N	2026-05-05 08:38:22.92414	\N
496c6adb-d047-4e6a-8388-968ba41d103d	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777970302919.jpg	\N	2026-05-05 08:38:22.924199	\N
a714e4f5-d0fc-4cab-b0d5-829762658712	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	fight_sounds	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777970303205.jpg	\N	2026-05-05 08:38:23.20938	\N
df98c8d3-6267-484d-95a6-a396b58a102a	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	fight_sounds	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777970303205.jpg	\N	2026-05-05 08:38:23.209434	\N
7d267447-551a-4f95-9ef8-4fecf5b6983d	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777970303555.jpg	\N	2026-05-05 08:38:23.560121	\N
a324b116-5c59-4d2b-aba4-f84a0e5411e1	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	fighting	fighting	medium	Demo Camera	/static/snapshots/snap_1777970303555.jpg	\N	2026-05-05 08:38:23.560177	\N
e67f6590-0a1c-4a78-a597-2a7ff40ec63f	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777970314994.jpg	\N	2026-05-05 08:38:35.000242	\N
c3cda369-e9ec-49d2-9a75-9ac75af8e53a	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777970314994.jpg	\N	2026-05-05 08:38:35.000296	\N
72a05b12-ba57-4b37-8892-013276ea055a	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777970318209.jpg	\N	2026-05-05 08:38:38.216081	\N
5c41d28a-85c4-4463-a8fc-a72f2d6a0760	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777970318209.jpg	\N	2026-05-05 08:38:38.216144	\N
7536fecf-085f-42e1-a733-796317731898	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777970320145.jpg	\N	2026-05-05 08:38:40.15164	\N
0f73eb39-2cc8-4b94-a901-55fb179b993d	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	vehicle_intrusion	vehicle_intrusion	medium	Demo Camera	/static/snapshots/snap_1777970320145.jpg	\N	2026-05-05 08:38:40.151697	\N
cd86bd66-02d1-4d8a-9c2c-f39595a03b80	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	abuse	abuse	high	Demo Camera	/static/snapshots/snap_1777970906514.jpg	\N	2026-05-05 08:48:26.518684	\N
35c6ad6a-89d5-455c-8a44-19c861824a48	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	abuse	abuse	high	Demo Camera	/static/snapshots/snap_1777970906514.jpg	\N	2026-05-05 08:48:26.518738	\N
71cf8917-ab02-4c19-8abc-25747e0a0b97	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777970906850.jpg	\N	2026-05-05 08:48:26.855076	\N
8e9ea96f-ae16-4600-a33b-20aed2fe7683	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	abuse	high	Demo Camera	/static/snapshots/snap_1777970906850.jpg	\N	2026-05-05 08:48:26.855128	\N
7aa2403b-8d32-4b5f-9036-6d40080609c6	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777970907425.jpg	\N	2026-05-05 08:48:27.42935	\N
c0fd32b7-ca11-445e-bb84-5bf376a16432	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777970907425.jpg	\N	2026-05-05 08:48:27.429401	\N
a7eef990-b898-49d1-aaac-a45caeab975b	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	fight_sounds	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777970907707.jpg	\N	2026-05-05 08:48:27.711879	\N
4eddc0ed-8b0a-4e44-a0a3-09e17d544d0d	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	fight_sounds	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777970907707.jpg	\N	2026-05-05 08:48:27.711935	\N
06b54483-29b7-4bd1-8ee7-b1783f441fd8	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777970923588.jpg	\N	2026-05-05 08:48:43.592377	\N
1b7e60a5-78bb-40c9-a69d-95f41e9f746d	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	intruder_detected	medium	Demo Camera	/static/snapshots/snap_1777970923588.jpg	\N	2026-05-05 08:48:43.592431	\N
35b273ec-9424-4b50-a815-26e3b2cfe8f9	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777970925569.jpg	\N	2026-05-05 08:48:45.573123	\N
656908f0-4faf-4daa-9818-f2f07d001602	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	robbery	high	Demo Camera	/static/snapshots/snap_1777970925569.jpg	\N	2026-05-05 08:48:45.573181	\N
1258eb92-d9f2-4523-9b05-9b34100c0894	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777970934340.jpg	\N	2026-05-05 08:48:54.344159	\N
6bff36c1-62d2-4cbf-a6fe-57c4221b9225	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1777970934340.jpg	\N	2026-05-05 08:48:54.344212	\N
8a77db82-88da-4b3f-ab9f-378a34cd3677	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777970923832.jpg	\N	2026-05-05 08:48:43.836829	\N
7f3aa122-dd04-4fac-934a-7b86a25cb4d9	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	fighting	medium	Demo Camera	/static/snapshots/snap_1777970923832.jpg	\N	2026-05-05 08:48:43.836883	\N
7bf92587-5988-404d-86be-3e8e4720688d	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	forced_entry	high	Demo Camera	/static/snapshots/snap_1777970931889.jpg	\N	2026-05-05 08:48:51.893499	\N
92239550-71e6-4dbb-8363-9f9bdc4fcc3d	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	forced_entry	high	Demo Camera	/static/snapshots/snap_1777970931889.jpg	\N	2026-05-05 08:48:51.893554	\N
0aa11979-a472-4513-8b63-6dd4a29f008b	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	car_crash	normal	medium	Demo Camera	/static/snapshots/snap_1777970937320.jpg	\N	2026-05-05 08:48:57.324411	\N
b93c17b6-e45e-4bb6-84fe-99589b7aefe9	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	car_crash	normal	medium	Demo Camera	/static/snapshots/snap_1777970937320.jpg	\N	2026-05-05 08:48:57.32447	\N
f8c08786-daad-4f67-b8ed-2e8e2a238b0b	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	distress_sounds	weapon_detected	high	Demo Camera	/static/snapshots/snap_1778580138355.jpg	\N	2026-05-12 10:02:18.367056	\N
749ba2b3-d9b7-4600-92bc-72d251fe5afa	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	distress_sounds	weapon_detected	high	Demo Camera	/static/snapshots/snap_1778580138355.jpg	\N	2026-05-12 10:02:18.367149	\N
b3378b9b-4142-405c-8589-8b9d8c2b7fca	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	violence	high	Demo Camera	/static/snapshots/snap_1778657392908.jpg	\N	2026-05-13 07:29:52.916585	\N
915ebe84-14fc-4488-9872-46575d755bf7	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	violence	high	Demo Camera	/static/snapshots/snap_1778657392908.jpg	\N	2026-05-13 07:29:52.916729	\N
7175531b-555e-4871-b282-228dc6eb705b	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	fight_sounds	weapon_detected	high	Demo Camera	/static/snapshots/snap_1778657394429.jpg	\N	2026-05-13 07:29:54.4342	\N
e0816832-cf1f-4fee-a7bd-f5d62a00e30c	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	fight_sounds	weapon_detected	high	Demo Camera	/static/snapshots/snap_1778657394429.jpg	\N	2026-05-13 07:29:54.434261	\N
cbd8b23e-b97c-4cdd-8423-8378d6119bf8	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	impact	normal	high	Demo Camera	/static/snapshots/snap_1778657394977.jpg	\N	2026-05-13 07:29:54.983296	\N
9dfc2a4d-c321-4f69-8b70-317e69761fcd	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	impact	normal	high	Demo Camera	/static/snapshots/snap_1778657394977.jpg	\N	2026-05-13 07:29:54.983355	\N
142e048d-9438-45de-90db-fd6022c18143	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	violence	high	Demo Camera	/static/snapshots/snap_1781112419747.jpg	\N	2026-06-10 17:26:59.758388	\N
f26f5781-243d-4711-b2fe-e760099fb4df	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	violence	high	Demo Camera	/static/snapshots/snap_1781112419747.jpg	\N	2026-06-10 17:26:59.758477	\N
a9447d5f-6ac0-405e-bfd6-b1c42f3a5430	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	impact	car_crash	high	Demo Camera	/static/snapshots/snap_1781112421117.jpg	\N	2026-06-10 17:27:01.12347	\N
4117c244-fa41-474f-9a1d-20bc02789296	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	impact	car_crash	high	Demo Camera	/static/snapshots/snap_1781112421117.jpg	\N	2026-06-10 17:27:01.123548	\N
e508df45-216b-470e-b57d-cfe5e91ae36e	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1781112426702.jpg	\N	2026-06-10 17:27:06.707541	\N
ca3a38d0-770e-4c75-9817-4eb6ffc3d128	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1781112426702.jpg	\N	2026-06-10 17:27:06.7076	\N
49909103-46ed-4444-a336-018464451345	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	violence	high	Demo Camera	/static/snapshots/snap_1781215150486.jpg	\N	2026-06-11 21:59:10.499055	\N
63c6cc90-9331-4ac4-8ab2-22b87b1bb9ff	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	violence	high	Demo Camera	/static/snapshots/snap_1781215150486.jpg	\N	2026-06-11 21:59:10.499131	\N
a6b9467e-cedd-4c42-9e64-e819bb9d71ab	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	impact	car_crash	high	Demo Camera	/static/snapshots/snap_1781215151713.jpg	\N	2026-06-11 21:59:11.719003	\N
e9414be8-7e7f-4445-a4cc-cceae8c2210d	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	impact	car_crash	high	Demo Camera	/static/snapshots/snap_1781215151713.jpg	\N	2026-06-11 21:59:11.719078	\N
a1b43087-60cc-408e-b8db-f688faaeaeb6	75bf04f9-2289-4776-a70a-e8d846c238fb	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1781215157263.jpg	\N	2026-06-11 21:59:17.268238	\N
36068856-e681-477c-aeec-196e4f94b9c6	a1337918-24cf-4f3f-a1ee-20ef779692d6	\N	normal	weapon_detected	high	Demo Camera	/static/snapshots/snap_1781215157263.jpg	\N	2026-06-11 21:59:17.268291	\N
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, user_id, "timestamp", audio_label, visual_label, fusion_score, alert_fired, zone, audio_confidence, visual_confidence, severity, total_events_in_chunk) FROM stdin;
6c0a6d3b-8fe7-49e2-b394-b64c7a5d083e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:17.924024	threatening_voice	normal	0.816	t	Demo Camera	0.47	0.816	high	1
84500b06-32aa-4f36-9c65-065b765391af	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:17.924141	threatening_voice	normal	0.816	t	Demo Camera	0.47	0.816	high	1
f515afdf-1e26-4944-951e-de2477dfc958	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:18.456969	threatening_voice	normal	0.782	t	Demo Camera	0.407	0.218	high	1
8d63e88b-d873-4e9f-8cc9-535f773ab7ad	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:18.457011	threatening_voice	normal	0.782	t	Demo Camera	0.407	0.218	high	1
ac67358d-cdad-4115-9e44-a2eeb16d98c2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:18.952506	vehicle_intrusion	vehicle_intrusion	0.385	t	Demo Camera	0.404	0.335	medium	1
e98b3350-558f-4f67-ab75-8f748fe12ee9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:18.952591	vehicle_intrusion	vehicle_intrusion	0.385	t	Demo Camera	0.404	0.335	medium	1
68d289fc-ee8a-4236-9e8c-03c187cbe981	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:54.834786	threatening_voice	normal	0.542	t	Demo Camera	0.542	0.194	high	1
b59b8f49-3988-4513-8d63-0c220eb6e2be	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:54.834822	threatening_voice	normal	0.542	t	Demo Camera	0.542	0.194	high	1
91a049de-243e-4023-b1f3-e5c5d2626893	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:55.3812	normal	normal	0.8	f	Demo Camera	0.757	0.8	low	1
12e18a0f-2389-4d59-b21e-c300baa497ae	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:55.381238	normal	normal	0.8	f	Demo Camera	0.757	0.8	low	1
47bbd374-ad5f-4fc2-9bf6-2f55b01c5e2c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:55.866092	vehicle_intrusion	vehicle_intrusion	0.366	t	Demo Camera	0.48	0.318	medium	1
29da4b3f-6588-409c-82e8-02ab9c777b5e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:55.866134	vehicle_intrusion	vehicle_intrusion	0.366	t	Demo Camera	0.48	0.318	medium	1
7bb49052-3600-4706-b613-df72628b79aa	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:40.714932	normal	normal	0.548	f	Demo Camera	0.391	0.548	low	1
799e2465-766f-4dc4-8d35-323faf857e88	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:40.71497	normal	normal	0.548	f	Demo Camera	0.391	0.548	low	1
2338197d-a2be-45ea-9ca6-57c56bbb26df	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:41.255931	normal	normal	0.718	f	Demo Camera	0.435	0.718	low	1
2e1e06d9-1b6e-4a04-835c-e5d25f2ceb8f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:41.255971	normal	normal	0.718	f	Demo Camera	0.435	0.718	low	1
62160caf-712b-4cf6-a204-c0bdfe3d78dd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:41.721922	vehicle_intrusion	vehicle_intrusion	0.37	t	Demo Camera	0.73	0.322	medium	1
33ed13a5-1512-4917-91e6-d8a4b5adc881	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:41.721997	vehicle_intrusion	vehicle_intrusion	0.37	t	Demo Camera	0.73	0.322	medium	1
9a2bb71c-4c25-4441-af33-8a9196c7bebf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:48.830136	normal	normal	0.407	f	Demo Camera	0.407	0.265	low	1
3702172c-dc00-4b12-a380-fe03eb0d00de	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:49.324029	normal	normal	0.665	f	Demo Camera	0.404	0.665	low	1
89f63574-3faa-4af4-918b-99660786f421	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:49.324063	normal	normal	0.665	f	Demo Camera	0.404	0.665	low	1
d911d4e6-60a5-4924-9d21-a1968f120859	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:52.309509	normal	normal	0.542	f	Demo Camera	0.542	0.194	low	1
6a7fad33-d3f1-4b90-85b0-d3326c472d27	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:52.309548	normal	normal	0.542	f	Demo Camera	0.542	0.194	low	1
23440c86-36a5-45bb-8130-bb78abdbbe34	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:52.852027	normal	normal	0.8	f	Demo Camera	0.243	0.8	low	1
b2f2ee78-f2cd-424c-b08e-280ee1a50611	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:52.85206	normal	normal	0.8	f	Demo Camera	0.243	0.8	low	1
dfd00391-5bb7-45cb-b1a9-1cf5022b6d17	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:53.292677	normal	normal	0.682	f	Demo Camera	0.48	0.682	low	1
430df55b-6911-44a5-8ff2-cb5b63805a08	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:53.292715	normal	normal	0.682	f	Demo Camera	0.48	0.682	low	1
59124cf6-ff98-4043-9b07-b885ec1ddeac	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:03.615909	normal	normal	0.855	f	Demo Camera	0.481	0.855	low	1
7a698ab5-d806-450a-90e0-ef3c1cf7585b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:03.615952	normal	normal	0.855	f	Demo Camera	0.481	0.855	low	1
c6047af0-68d0-4a42-a954-39ab0769fa3c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:03.841266	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
0e3ecb43-9794-44a1-ac09-e3ad7f416658	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:03.841301	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
4c458593-fe62-40cb-a327-596e7844d0ad	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.068413	normal	normal	0.626	f	Demo Camera	0.519	0.626	low	1
d0c394b2-3f32-4a9e-851b-b66980d70e0c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.068446	normal	normal	0.626	f	Demo Camera	0.519	0.626	low	1
1b819f05-5713-4ea5-acd0-5ebb1141dd7b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.274747	normal	normal	0.693	f	Demo Camera	0.533	0.693	low	1
4b38e2f0-9ea1-4100-8428-c0ac31717ed6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.274786	normal	normal	0.693	f	Demo Camera	0.533	0.693	low	1
a2276921-2658-4fe6-a173-52a5f5ae4b86	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.499682	normal	fighting	0.556	t	Demo Camera	0.369	0.556	medium	1
8f5ac217-fe20-47f0-947d-2909ff97231d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.499717	normal	fighting	0.556	t	Demo Camera	0.369	0.556	medium	1
b9880911-845b-4c37-ac6c-abea7f2baf07	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.712204	normal	fighting	0.624	t	Demo Camera	0.375	0.624	medium	1
3cfe79d1-bc75-4fe0-bd88-2c5af9090085	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.712238	normal	fighting	0.624	t	Demo Camera	0.375	0.624	medium	1
6d4a7c41-cdc5-42ef-bf6a-1cba78c30d3c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.928249	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
fef8a783-f191-4970-985a-54264033eb5e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.92829	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
bd6e8302-e7fe-4ee5-b4e1-49da7a741d15	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.152106	normal	normal	0.61	f	Demo Camera	0.61	0.555	low	1
f791781a-3438-4449-9708-3ce7d02af63d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.152139	normal	normal	0.61	f	Demo Camera	0.61	0.555	low	1
94357bf5-357c-4fae-bad3-beb0edbb7aeb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:18.069166	threatening_voice	normal	0.542	t	Demo Camera	0.542	0.194	high	1
ce25fe52-def9-42d5-93a7-8b29fbe6feed	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:18.069208	threatening_voice	normal	0.542	t	Demo Camera	0.542	0.194	high	1
9fdac26b-7342-4de2-8036-c12fbc287add	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:18.61428	normal	normal	0.8	f	Demo Camera	0.757	0.8	low	1
c0fa7d59-0b1e-478b-99fc-9873434a6247	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:18.614325	normal	normal	0.8	f	Demo Camera	0.757	0.8	low	1
f004a567-7b59-4497-819b-ff13f3f4bbf8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:19.059717	vehicle_intrusion	vehicle_intrusion	0.366	t	Demo Camera	0.48	0.318	medium	1
00be5a0c-f797-4f0c-940c-ae3b5c204ac1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:19.059757	vehicle_intrusion	vehicle_intrusion	0.366	t	Demo Camera	0.48	0.318	medium	1
5750ca3c-88d3-42c2-8caa-f6e79d96d00f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:54.944446	normal	normal	0.609	f	Demo Camera	0.609	0.548	low	1
de23291f-fc7d-4e0b-b2fb-6c7aaef7798b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:54.944488	normal	normal	0.609	f	Demo Camera	0.609	0.548	low	1
dd7a1f3e-1053-467a-8fcd-31308710169b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:55.518385	threatening_voice	normal	0.718	t	Demo Camera	0.435	0.718	high	1
e31ee8ea-fdfc-42fc-b11c-0147ca7e1e81	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:55.518426	threatening_voice	normal	0.718	t	Demo Camera	0.435	0.718	high	1
d6e4b806-7f54-4ff4-92c6-119d1f554f62	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:56.000448	vehicle_intrusion	vehicle_intrusion	0.37	t	Demo Camera	0.73	0.322	medium	1
d92ebcbf-3039-4db6-a938-9690bb8a4a79	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:56.000493	vehicle_intrusion	vehicle_intrusion	0.37	t	Demo Camera	0.73	0.322	medium	1
ae9561c8-222a-41e8-b93f-feae6b71f1f6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:40.863957	normal	normal	0.786	f	Demo Camera	0.4	0.786	low	1
57bb2347-fe16-4b46-95f0-ffeb942cd8ed	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:40.863997	normal	normal	0.786	f	Demo Camera	0.4	0.786	low	1
13eb8aca-c08a-4586-8037-a5b010a2014c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:41.353869	normal	normal	0.702	f	Demo Camera	0.309	0.702	low	1
aa0a95bc-e022-45ca-a327-456ec2ce3838	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:41.353908	normal	normal	0.702	f	Demo Camera	0.309	0.702	low	1
aabe489e-16cf-4f8f-971b-a5977dd25a36	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.017661	normal	fighting	0.758	t	Demo Camera	0.615	0.758	medium	1
4afa4f26-006b-435e-b2dd-1ce265540e5a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.218082	normal	fighting	0.481	t	Demo Camera	0.452	0.481	medium	1
a9464830-f7d0-46a9-8869-1a6148a56611	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.218116	normal	fighting	0.481	t	Demo Camera	0.452	0.481	medium	1
15fe61dc-c6b9-42e4-a827-9ebf3030994a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.444802	normal	intruder_detected	0.54	t	Demo Camera	0.49	0.54	medium	1
3b32c0fa-4dc2-41ed-ad19-393c71d40631	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.44484	normal	intruder_detected	0.54	t	Demo Camera	0.49	0.54	medium	1
7f8ddc35-1a5e-4daf-9d5c-45ef6aefd933	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.660646	normal	fighting	0.773	t	Demo Camera	0.677	0.773	medium	1
1c868428-3a19-436e-893c-ec4bdf2631e7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.660686	normal	fighting	0.773	t	Demo Camera	0.677	0.773	medium	1
fd91f988-3c98-40e4-bc29-129a678c8a73	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.873167	normal	normal	0.62	f	Demo Camera	0.53	0.62	low	1
6985c91a-45a8-40fa-b876-a14d419b0732	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.8732	normal	normal	0.62	f	Demo Camera	0.53	0.62	low	1
c2b52ffd-ab7c-4e0a-a092-b75ca7b07934	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.080172	normal	normal	0.705	f	Demo Camera	0.473	0.705	low	1
a9cd77ab-2a14-4c53-8c42-2ded9ae2da57	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.080213	normal	normal	0.705	f	Demo Camera	0.473	0.705	low	1
4657f1df-af22-4ae3-b6b5-e8850b352af9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.295752	normal	fighting	0.627	t	Demo Camera	0.627	0.587	medium	1
0ede839a-e21b-4d9b-b3ce-c1f5ec4697cf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.295789	normal	fighting	0.627	t	Demo Camera	0.627	0.587	medium	1
34699c5d-2165-43d6-ad92-c65cb509e479	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.344431	normal	fighting	0.908	t	Demo Camera	0.424	0.908	medium	1
802fbed2-0ed3-4e08-8985-04119d682235	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.344471	normal	fighting	0.908	t	Demo Camera	0.424	0.908	medium	1
1a20c67e-5575-436c-b1fb-75bfedea0fca	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.511944	normal	normal	0.662	f	Demo Camera	0.237	0.662	low	1
8139b29a-92c0-4b5c-85db-6d9c228f6691	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.51198	normal	normal	0.662	f	Demo Camera	0.237	0.662	low	1
b82d585b-395f-4211-a95e-148d3ba45e8e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.565637	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
c76baae1-6226-4903-8fa6-246b9aeda544	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.565675	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
a0e9f49b-3d6b-4c06-8ec1-d1bf70d84e0e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.728281	normal	fighting	0.656	t	Demo Camera	0.238	0.656	medium	1
3253c354-51da-411c-b0b0-f21a711f4b17	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.728315	normal	fighting	0.656	t	Demo Camera	0.238	0.656	medium	1
d28676bf-aada-466a-90d2-91aa9e1cdb56	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.775096	normal	normal	0.752	f	Demo Camera	0.504	0.752	low	1
63be2a39-63a0-4f54-af28-9963ecbdc1d5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.775129	normal	normal	0.752	f	Demo Camera	0.504	0.752	low	1
052223db-fb67-48dd-bda9-ead7af39848a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.924374	normal	normal	0.611	f	Demo Camera	0.569	0.611	low	1
7c463d59-f1ad-4bff-acb3-ee52b792d7a8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.924412	normal	normal	0.611	f	Demo Camera	0.569	0.611	low	1
4345556c-42de-40d8-af22-48dbfd1651bb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.975901	normal	normal	0.787	f	Demo Camera	0.274	0.787	low	1
caf31a58-8c90-48d7-bae2-c34df96e87ce	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.975937	normal	normal	0.787	f	Demo Camera	0.274	0.787	low	1
80930da4-b845-4ddb-9c8d-4ec516c48614	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:18.179672	normal	normal	0.609	f	Demo Camera	0.609	0.548	low	1
adb0513c-bfb1-4045-8eb5-5d27132f6731	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:18.179719	normal	normal	0.609	f	Demo Camera	0.609	0.548	low	1
cc6a00f3-ea5b-4efd-82af-25d24dd186f4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:18.732875	threatening_voice	normal	0.718	t	Demo Camera	0.435	0.718	high	1
d0265da3-fd66-4cca-91c0-63403c924832	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:18.732918	threatening_voice	normal	0.718	t	Demo Camera	0.435	0.718	high	1
bec1fc3f-0bf5-407d-b841-4cbf05a5c089	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:19.187345	vehicle_intrusion	vehicle_intrusion	0.37	t	Demo Camera	0.73	0.322	medium	1
33a5df48-f5f0-427b-a2d6-bc78a243713b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:19.187385	vehicle_intrusion	vehicle_intrusion	0.37	t	Demo Camera	0.73	0.322	medium	1
6f2d786a-e81f-4d12-a675-9c60e716990b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:55.10249	threatening_voice	normal	0.786	t	Demo Camera	0.4	0.786	high	1
b477a0fc-6064-4978-baa5-27df53afb82c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:55.102525	threatening_voice	normal	0.786	t	Demo Camera	0.4	0.786	high	1
c486a18d-db22-42a7-abdd-2f8f2b8f913c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:55.622347	normal	normal	0.702	f	Demo Camera	0.691	0.702	low	1
6992a621-8349-49af-ba26-06582c584c16	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:55.62238	normal	normal	0.702	f	Demo Camera	0.691	0.702	low	1
fa6e3117-0663-450b-a47a-019190f01f2d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:40.455933	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
79dcd9af-ebd2-4292-9aa8-28b61a8f178e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:40.455991	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
cbaac615-1d01-43b6-a7bb-29897e110710	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:40.977858	normal	normal	0.782	f	Demo Camera	0.407	0.218	low	1
7a051286-b3ef-4b7b-9f6d-c4509182a1af	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:40.977894	normal	normal	0.782	f	Demo Camera	0.407	0.218	low	1
6c6cc2cc-35db-4085-9052-dd3780f77e6c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:41.487899	normal	vehicle_intrusion	0.404	t	Demo Camera	0.404	0.335	medium	1
0d3660b4-00dd-4ff4-8122-ec5ae3ecdd0a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:41.487993	normal	vehicle_intrusion	0.404	t	Demo Camera	0.404	0.335	medium	1
d4ca3027-d685-4332-9c46-77718f0f0a27	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.164567	normal	fighting	0.538	t	Demo Camera	0.345	0.538	medium	1
6590fc41-9c97-44b3-8238-1bb9ee8007e7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.387277	normal	fighting	0.76	t	Demo Camera	0.353	0.76	medium	1
e1d1943b-ad5c-419f-9633-867b50ac14cf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.387313	normal	fighting	0.76	t	Demo Camera	0.353	0.76	medium	1
ac3f5ee9-f02d-4d39-8766-0e085b0e5aa6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.60643	normal	normal	0.76	f	Demo Camera	0.551	0.76	low	1
136224dd-c461-477d-ae24-bfa8f39c27c4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.606471	normal	normal	0.76	f	Demo Camera	0.551	0.76	low	1
4a68b659-dda0-4047-8bd3-7f764b44106d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.821243	normal	normal	0.573	f	Demo Camera	0.242	0.573	low	1
53245232-2704-4523-b1af-15eaf518a575	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.821276	normal	normal	0.573	f	Demo Camera	0.242	0.573	low	1
1e9dc77f-e7ec-43dd-9592-6033c4d0a67f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.027511	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
6515a2f5-45bf-4a09-a8b4-ef5f1094706a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.027548	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
0107fcb1-6042-40ec-9bd9-a43cf5ffe575	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.248792	normal	normal	0.564	f	Demo Camera	0.35	0.564	low	1
782ba42e-d0d3-4469-ad7d-53d63f10d161	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.248826	normal	normal	0.564	f	Demo Camera	0.35	0.564	low	1
2ea09436-ba8a-4f89-9255-37086b72494d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.455635	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
f9b0053c-94f8-4b4d-bc3e-8303f0f08734	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.455674	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
99dff97b-42b8-4c72-9048-b0267f148da8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.674362	normal	normal	0.688	f	Demo Camera	0.239	0.688	low	1
85c7902a-8abc-4553-ad05-2284579f85f4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.674401	normal	normal	0.688	f	Demo Camera	0.239	0.688	low	1
b0e01ea1-2f88-4380-a9b7-1fb2b32e5cc4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.87463	normal	normal	0.719	f	Demo Camera	0.522	0.719	low	1
b4021407-1234-4871-b1bf-d2bbc908bdc3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.874663	normal	normal	0.719	f	Demo Camera	0.522	0.719	low	1
bd458cea-44e3-4346-b154-89e7dadf46fa	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.075068	normal	fighting	0.592	t	Demo Camera	0.397	0.592	medium	1
eca590dc-d587-4000-9956-a9ad0cb8365a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.075106	normal	fighting	0.592	t	Demo Camera	0.397	0.592	medium	1
515e4e17-156d-4044-a74e-6e1643346aaa	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.129293	normal	normal	0.652	f	Demo Camera	0.652	0.562	low	1
256cd639-9d53-4e71-88e5-7445d9194ae8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.129338	normal	normal	0.652	f	Demo Camera	0.652	0.562	low	1
d45d76b6-ec73-4f5c-a6a9-fa7f2cc451db	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.298491	normal	fighting	0.6	t	Demo Camera	0.6	0.492	medium	1
64ac7d78-7b75-4ce0-bdcb-c99d79f24621	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.298526	normal	fighting	0.6	t	Demo Camera	0.6	0.492	medium	1
1edce6ad-416d-44a6-bd9e-fc130ed34370	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.350394	normal	normal	0.802	f	Demo Camera	0.495	0.802	low	1
23440566-f130-4898-9304-2989995aa62c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.350428	normal	normal	0.802	f	Demo Camera	0.495	0.802	low	1
79f042ff-2536-4a77-b295-6271978c6a11	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.566847	normal	normal	0.44	f	Demo Camera	0.328	0.44	low	1
2a7475fe-abcf-46f4-9908-844ff1094f0b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.566888	normal	normal	0.44	f	Demo Camera	0.328	0.44	low	1
33b3f123-717a-4240-bdb5-694b0776d273	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:18.340204	threatening_voice	normal	0.786	t	Demo Camera	0.4	0.786	high	1
0ac453a3-83bb-4571-82d3-b2fc0f8be7e6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:18.340241	threatening_voice	normal	0.786	t	Demo Camera	0.4	0.786	high	1
2f22b8dd-7c2f-46ff-bfdb-260b4607a69a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:02:18.82473	normal	normal	0.702	f	Demo Camera	0.691	0.702	low	1
07c8f0f5-7117-45b2-89c5-943a1b71a1fc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:02:18.824765	normal	normal	0.702	f	Demo Camera	0.691	0.702	low	1
15c468d8-597b-4655-97d4-6aa827959f6c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:54.685953	threatening_voice	normal	0.816	t	Demo Camera	0.47	0.816	high	1
f342cce9-57a8-44b2-8d76-bbcf814fea33	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:54.686037	threatening_voice	normal	0.816	t	Demo Camera	0.47	0.816	high	1
bc9475c2-04a2-4300-a217-8a5e9a136cc6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:55.217992	threatening_voice	normal	0.782	t	Demo Camera	0.407	0.218	high	1
392cfb50-3c23-4f9d-a944-8af8cc791ce4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:55.218026	threatening_voice	normal	0.782	t	Demo Camera	0.407	0.218	high	1
1317571e-2a8a-496a-8bd5-aa38da19c23b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:04:55.760245	vehicle_intrusion	vehicle_intrusion	0.385	t	Demo Camera	0.404	0.335	medium	1
180fbf5f-48af-4592-b7c3-f39ca2f2ae4b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:04:55.760328	vehicle_intrusion	vehicle_intrusion	0.385	t	Demo Camera	0.404	0.335	medium	1
103fc9de-fcae-432b-924f-07fbd308d3e1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:40.605458	normal	normal	0.542	f	Demo Camera	0.542	0.194	low	1
6450e161-2a1e-49df-8bd8-dd87fc31a213	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:40.605493	normal	normal	0.542	f	Demo Camera	0.542	0.194	low	1
0a01424b-cce6-4913-b2b2-40857072587f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:41.136945	normal	normal	0.8	f	Demo Camera	0.243	0.8	low	1
b8dd0498-1c72-42b4-8b33-b54311d0c384	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:41.136986	normal	normal	0.8	f	Demo Camera	0.243	0.8	low	1
473cfb3a-723c-42ee-bc8f-a627b33a3c83	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:13:41.595858	normal	vehicle_intrusion	0.48	t	Demo Camera	0.48	0.318	medium	1
6c7a402f-f6d7-40d0-b674-77f1d2a035bc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:13:41.595906	normal	vehicle_intrusion	0.48	t	Demo Camera	0.48	0.318	medium	1
925961f7-8507-4fad-99a5-6735caa0e913	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.764986	normal	normal	0.886	f	Demo Camera	0.73	0.886	low	1
ba8127e4-b078-435d-950d-48a58bdc0fff	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.977814	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
9a27a250-011b-464f-bcd4-a11431cb7afc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.977852	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
5018860e-93fa-4e45-a639-1faf9f56b487	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.199873	normal	fighting	0.755	t	Demo Camera	0.623	0.755	medium	1
3964380f-edfc-47bf-83ae-7303d5ec48ed	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.199908	normal	fighting	0.755	t	Demo Camera	0.623	0.755	medium	1
e710e579-7329-41e9-81e5-84864cecb255	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.397672	normal	normal	0.752	f	Demo Camera	0.27	0.752	low	1
32cf3f26-d363-423d-bbd7-e22aa4a500c3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.397704	normal	normal	0.752	f	Demo Camera	0.27	0.752	low	1
913be945-e697-4785-b861-f190362a1474	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.61852	normal	normal	0.617	f	Demo Camera	0.617	0.612	low	1
dcfd6d12-b20e-49ee-b22b-fc22a0bc7135	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.618554	normal	normal	0.617	f	Demo Camera	0.617	0.612	low	1
51cb6781-4a46-460a-93b2-80064a923edf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:05.823445	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
d9924fbd-ff47-4fd6-b1ab-f70a01b169da	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:05.823485	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
c6b1c8f6-dca9-4378-959c-bc9bee5ca194	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.020755	normal	fighting	0.786	t	Demo Camera	0.656	0.786	medium	1
0d71c6ef-e23f-47f7-9fa4-6b4491dcdddb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.02079	normal	fighting	0.786	t	Demo Camera	0.656	0.786	medium	1
cef4cdb0-75d1-4856-b206-3fa7fad110f5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.186298	normal	fighting	0.765	t	Demo Camera	0.765	0.496	medium	1
fb03c074-a997-4cfe-b83b-380893629052	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.186333	normal	fighting	0.765	t	Demo Camera	0.765	0.496	medium	1
cf57c784-37bb-499c-a22a-1a6cc507312b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.236558	normal	normal	0.722	f	Demo Camera	0.391	0.722	low	1
95fcf2b0-3cf6-458f-aa88-d624b1e4a5db	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.236593	normal	normal	0.722	f	Demo Camera	0.391	0.722	low	1
207dd8a3-8a42-48da-9ffe-c46ec1e4d82f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.419957	normal	normal	0.791	f	Demo Camera	0.417	0.791	low	1
e1e318b4-ea7f-4f50-bd2a-816fd0056e78	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.419991	normal	normal	0.791	f	Demo Camera	0.417	0.791	low	1
9b2c696f-df83-45d6-b122-5d7cf7925bff	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:06.48618	normal	normal	0.429	f	Demo Camera	0.429	0.383	low	1
255cbaaa-7914-42e3-a2b1-f3454394e0d0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:06.48622	normal	normal	0.429	f	Demo Camera	0.429	0.383	low	1
b6ae5eae-ea43-4a87-9a44-79db29cdb7bc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:29.47693	normal	normal	0.722	f	Demo Camera	0.874	0.722	low	1
f2da10e1-1772-4cb2-9f53-6176b2a0294f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:29.476963	normal	normal	0.722	f	Demo Camera	0.874	0.722	low	1
4fab6779-9b74-484b-bfed-881d609633a2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:29.57579	normal	normal	0.813	f	Demo Camera	0.372	0.813	low	1
3a433c56-72a8-4047-b0f3-551573c94528	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:29.575829	normal	normal	0.813	f	Demo Camera	0.372	0.813	low	1
6f1b56dd-69b4-46d0-bad9-0daef0a6d718	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:29.632501	normal	normal	0.651	f	Demo Camera	0.651	0.627	low	1
3696479c-4ac6-44f3-882a-a56a86e1cb9a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:29.632544	normal	normal	0.651	f	Demo Camera	0.651	0.627	low	1
e5944b86-64da-4d26-8cdd-6e37cff343ce	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:48.302534	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
dbb28a39-de10-40a1-9d61-31b4cdc84211	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:48.302581	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
4affc549-a774-4532-86b3-abd0936bafc5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:48.830098	normal	normal	0.407	f	Demo Camera	0.407	0.265	low	1
187f9609-25ff-40a2-bee4-2c7322eea656	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:31.676373	intruder_detected	intruder_detected	0.997	t	Demo Camera	0.309	0.867	medium	1
9ec30ad9-e66b-4e60-9dc1-c219bafb556c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:31.676491	intruder_detected	intruder_detected	0.997	t	Demo Camera	0.309	0.867	medium	1
b6ef966a-92a1-42a2-b979-a526a97cb116	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:31.747382	normal	fighting	0.601	t	Demo Camera	0.601	0.497	medium	1
7a9a8e6c-ed65-424c-a0a4-4cd26a3ad431	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:31.747483	normal	fighting	0.601	t	Demo Camera	0.601	0.497	medium	1
6647a77d-b108-48d0-a908-111f9832e317	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:31.824251	car_crash	normal	0.855	t	Demo Camera	0.481	0.855	medium	1
e4bddfbc-42f5-421c-ae71-53e85fd14c7a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:31.824353	car_crash	normal	0.855	t	Demo Camera	0.481	0.855	medium	1
9fcbe2f8-462f-4183-b1c3-1cac7e658c38	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:31.910434	normal	normal	0.798	f	Demo Camera	0.475	0.798	low	1
6ff3b361-75dd-4696-bd00-2c75861d57db	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:31.910489	normal	normal	0.798	f	Demo Camera	0.475	0.798	low	1
76a43f45-5cda-4f2c-bc3c-0be4987e341d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:31.972609	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
ccb5a345-2753-4b47-9413-755ba7960e79	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:31.972645	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
dc824baf-37ae-48d3-8fe5-2e6f182b3954	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.024283	normal	normal	0.757	f	Demo Camera	0.337	0.757	low	1
d2ab5b1d-3d51-4fc2-81ed-88b0ce12af92	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.02434	normal	normal	0.757	f	Demo Camera	0.337	0.757	low	1
1f9ec18e-471e-4bb0-92fe-b570af68330d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.089508	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
da2842a7-9494-47ce-ab3a-9a31b2be335d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.089543	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
a3b654e5-875d-44c8-99e7-94a4ea583b36	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.145243	normal	fighting	0.446	t	Demo Camera	0.446	0.342	medium	1
c72fd118-a9b2-4ca8-b5c1-b791a400ac04	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.145285	normal	fighting	0.446	t	Demo Camera	0.446	0.342	medium	1
aa57697a-2502-47b0-a56f-9e49e47b88b0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.208453	normal	fighting	0.661	t	Demo Camera	0.263	0.661	medium	1
63e338f9-7978-4e90-872e-63f4580cb0a6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.481749	normal	fighting	0.481	t	Demo Camera	0.452	0.481	medium	1
06f9e06d-ab50-48a6-b2e0-fb97f8a0fd0c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.4818	normal	fighting	0.481	t	Demo Camera	0.452	0.481	medium	1
f663ac0b-c089-4b39-8bbc-8bc504853078	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.706478	normal	intruder_detected	0.54	t	Demo Camera	0.49	0.54	medium	1
13e923aa-4e98-49d4-9dcf-c7aa8eaa43c2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.706516	normal	intruder_detected	0.54	t	Demo Camera	0.49	0.54	medium	1
2fc23f79-891f-4c55-a6c5-4bb35e7c7cf2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.938063	normal	fighting	0.773	t	Demo Camera	0.677	0.773	medium	1
5ba4150d-270e-41a0-a8f4-844d50c090cf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.938103	normal	fighting	0.773	t	Demo Camera	0.677	0.773	medium	1
6cbf6fac-08c7-4bfe-aa9c-2e3ee0df9d80	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.147834	normal	forced_entry	0.53	t	Demo Camera	0.53	0.38	high	1
2b38a6cb-50e2-4c56-abad-375da75f21c1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.14792	normal	forced_entry	0.53	t	Demo Camera	0.53	0.38	high	1
0a03a97e-0498-4e29-914c-3fa9506205d9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.265752	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
3c308e6e-d703-4977-9748-f3ae3fbd77ac	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.265794	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
a048299a-70a0-443b-9ead-3d97ba7c999a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.604641	normal	fighting	0.627	t	Demo Camera	0.627	0.587	medium	1
d2c8f09d-de72-49eb-b243-43bce529a1ed	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.60468	normal	fighting	0.627	t	Demo Camera	0.627	0.587	medium	1
a4a02ff9-a384-48fd-b983-4e014e2875ac	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.825087	normal	fighting	0.338	t	Demo Camera	0.237	0.338	medium	1
6e7fd256-b020-4f83-b765-578db2cbcc3a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.825129	normal	fighting	0.338	t	Demo Camera	0.237	0.338	medium	1
3e949e04-fc9e-42fa-bef9-938c60a50342	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.163526	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
a057127e-b4db-4bdc-9be0-7b84cee314fe	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.163561	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
ac51b4bb-a826-4f53-a442-fc2e48007ead	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.261142	normal	fighting	0.569	t	Demo Camera	0.569	0.389	medium	1
99562617-ba5e-4210-b295-04e209dacba6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.261182	normal	fighting	0.569	t	Demo Camera	0.569	0.389	medium	1
b14abf69-77cf-4952-ba39-6bb0855b4cbf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.487396	normal	forced_entry	0.652	t	Demo Camera	0.652	0.438	high	1
5d1dedb3-b23b-421b-abfa-3112cd724ff8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.487444	normal	forced_entry	0.652	t	Demo Camera	0.652	0.438	high	1
706c3084-fb5d-4277-a216-05a4f42fc346	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.880636	car_crash	normal	0.768	t	Demo Camera	0.334	0.232	medium	1
742d98d7-e3fc-4f17-9f74-a21e92fcbf4b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.88067	car_crash	normal	0.768	t	Demo Camera	0.334	0.232	medium	1
62068203-0bc8-4f52-9c95-9dc0ee37ebe8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.208489	normal	fighting	0.661	t	Demo Camera	0.263	0.661	medium	1
48de8afd-45ec-4874-bd4d-d3947ef7318a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.537761	normal	intruder_detected	0.533	t	Demo Camera	0.533	0.307	medium	1
af128b72-fae7-4ec4-ab2b-a2452e3ccc9f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.537803	normal	intruder_detected	0.533	t	Demo Camera	0.533	0.307	medium	1
d8e6d5c1-6043-4d18-b96d-b5ab4c8faeab	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.758134	normal	fighting	0.556	t	Demo Camera	0.369	0.556	medium	1
a9fa209c-e351-47e9-87cf-11071122d1ce	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.758173	normal	fighting	0.556	t	Demo Camera	0.369	0.556	medium	1
1dc7cc1d-65f0-48bb-86a9-b7024a30b671	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.988742	normal	fighting	0.624	t	Demo Camera	0.375	0.624	medium	1
a1cfa412-b3b9-49c1-b175-8c6c62f8e5f9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.988778	normal	fighting	0.624	t	Demo Camera	0.375	0.624	medium	1
6ae09576-5c8d-44ab-9481-966e0cc323d2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.317018	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
0d7fcd93-6d42-4662-9c0f-401c232546bf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.317061	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
0971f5cc-5e94-4423-9f5f-204e796ba6d1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.653106	normal	fighting	0.908	t	Demo Camera	0.424	0.908	medium	1
a2378391-7b5a-4506-aec0-5e72631746b7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.653142	normal	fighting	0.908	t	Demo Camera	0.424	0.908	medium	1
ee8c516c-8419-44c5-b84e-dc12e6f77715	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.882101	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
99e12866-0cf2-45fd-813a-980653f9a432	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.882146	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
6738d375-d910-4ae7-ac45-1129e2c5bda7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.207764	normal	weapon_detected	0.522	t	Demo Camera	0.522	0.333	high	1
c4514a4a-663e-44f5-9be2-61a4170416be	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.207835	normal	weapon_detected	0.522	t	Demo Camera	0.522	0.333	high	1
27dc1bfb-d2e6-434c-bc79-40655113a28d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.315148	normal	normal	0.787	f	Demo Camera	0.274	0.787	low	1
ca5e5f05-80b0-404d-ba1f-5895c5a3fbfa	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.315182	normal	normal	0.787	f	Demo Camera	0.274	0.787	low	1
9df9f9e2-3e77-47d4-abc1-a2d25dcf6b87	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.548076	normal	fighting	0.765	t	Demo Camera	0.765	0.496	medium	1
b0c3390f-9689-46f8-8299-9eed758ebc0b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.548162	normal	fighting	0.765	t	Demo Camera	0.765	0.496	medium	1
c63847a1-d6b9-48fe-aa53-366e2b23c636	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.95537	normal	normal	0.672	f	Demo Camera	0.672	0.44	low	1
029681bd-47ee-47ce-8aa9-054901c5b89c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.955405	normal	normal	0.672	f	Demo Camera	0.672	0.44	low	1
68419070-ce78-4958-b681-503cf0b15708	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:48.453577	normal	normal	0.542	f	Demo Camera	0.542	0.194	low	1
3fb2b77f-6de2-40a7-8791-2211e4e6fe11	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:48.453616	normal	normal	0.542	f	Demo Camera	0.542	0.194	low	1
102b077a-a43d-496e-8110-e590e9d4e2f5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:48.986472	normal	normal	0.8	f	Demo Camera	0.243	0.8	low	1
55bc763f-c79a-4794-b391-ab98fb7b748c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:48.986506	normal	normal	0.8	f	Demo Camera	0.243	0.8	low	1
c4a2cdca-77f0-48d8-acb5-28b2b37b0959	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:49.423484	normal	normal	0.682	f	Demo Camera	0.48	0.682	low	1
945be164-fc25-4a1b-8cea-5192f07a91db	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:49.423523	normal	normal	0.682	f	Demo Camera	0.48	0.682	low	1
d29e8d6a-b435-4051-a0ba-7ba396ef982d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:52.436072	normal	normal	0.548	f	Demo Camera	0.391	0.548	low	1
1cc4ad15-d228-4ae5-b11a-875ee91033cf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:52.436111	normal	normal	0.548	f	Demo Camera	0.391	0.548	low	1
ccc4fbe5-2297-4471-9ba6-6e7add916ff0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:52.969587	normal	normal	0.718	f	Demo Camera	0.435	0.718	low	1
423899de-973d-4008-ba24-872f2f6232c8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:52.969621	normal	normal	0.718	f	Demo Camera	0.435	0.718	low	1
159f2527-1fa7-4170-b0be-0861fa96ffe1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:53.41441	normal	normal	0.678	f	Demo Camera	0.73	0.678	low	1
a99160bf-55dd-41ca-b21b-0ac810ec6619	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:53.414449	normal	normal	0.678	f	Demo Camera	0.73	0.678	low	1
791bf48e-9f59-4a5c-9255-80341ccf1807	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:03.670763	normal	normal	0.798	f	Demo Camera	0.475	0.798	low	1
ef40ca7a-c613-48f2-ad20-5a2ab23f99b1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:03.670796	normal	normal	0.798	f	Demo Camera	0.475	0.798	low	1
55f8333c-a13c-4f06-b5ba-a107c0205e42	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:03.887689	normal	normal	0.658	f	Demo Camera	0.446	0.658	low	1
bb93599c-1232-42ae-bb25-f18563287238	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:03.887738	normal	normal	0.658	f	Demo Camera	0.446	0.658	low	1
1979ad7b-2283-4d3b-9b17-b591dfcdc953	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.115092	normal	fighting	0.509	t	Demo Camera	0.295	0.509	medium	1
e669d683-ebe1-4e08-8494-fa629fceb36d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.115129	normal	fighting	0.509	t	Demo Camera	0.295	0.509	medium	1
17143b24-af6b-4657-803c-0e5ca3f732e4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.332506	normal	normal	0.614	f	Demo Camera	0.487	0.614	low	1
1fb8cddc-b325-48db-bd8d-9c8000a2f786	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.332541	normal	normal	0.614	f	Demo Camera	0.487	0.614	low	1
cef07b85-27d5-4fb5-bec7-5dfeb2e5ddab	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.554959	normal	normal	0.611	f	Demo Camera	0.572	0.611	low	1
d0238e6c-e004-41b2-9e08-df31f06ba7d8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:04.554993	normal	normal	0.611	f	Demo Camera	0.572	0.611	low	1
6187efc2-2b3f-4d15-858b-dcb725b87006	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.764953	normal	normal	0.886	f	Demo Camera	0.73	0.886	low	1
81d3e66c-6434-43ef-9b49-6c4febc7103e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.260667	normal	fighting	0.758	t	Demo Camera	0.615	0.758	medium	1
b290da1b-4360-4edb-87a5-30450a81dcaa	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.260705	normal	fighting	0.758	t	Demo Camera	0.615	0.758	medium	1
57071349-3bd2-491c-ad47-70da982a61b2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.373192	normal	fighting	0.808	t	Demo Camera	0.192	0.509	medium	1
1b6a36f1-2237-45ee-8181-67d3c313c05f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.37328	normal	fighting	0.808	t	Demo Camera	0.192	0.509	medium	1
d7f0dee7-bd4a-49a7-929e-cf219d4ff44f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.597202	normal	fighting	0.487	t	Demo Camera	0.487	0.386	medium	1
92cfe1f3-284c-4f02-9931-7ae745bb7dea	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.597235	normal	fighting	0.487	t	Demo Camera	0.487	0.386	medium	1
ab7c5c3e-aea6-45b6-a602-eb4fe15eb966	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.817886	normal	intruder_detected	0.572	t	Demo Camera	0.572	0.389	medium	1
74bd59b4-fb3f-4936-9a9f-ad544eaa7497	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.817926	normal	intruder_detected	0.572	t	Demo Camera	0.572	0.389	medium	1
85cfe176-4f30-471b-9655-c183579d1040	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.037372	normal	normal	0.886	f	Demo Camera	0.73	0.886	low	1
f9d5e313-bfdc-4a41-98df-c1538ed4007d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.037406	normal	normal	0.886	f	Demo Camera	0.73	0.886	low	1
d298b233-1afb-4e24-b8d8-5087f7411cbf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.368994	normal	normal	0.705	f	Demo Camera	0.473	0.705	low	1
978c8a73-8f7e-4167-be88-e3c72e4dafcd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.369038	normal	normal	0.705	f	Demo Camera	0.473	0.705	low	1
32322c58-4274-414c-90dd-dfd8ca1a3637	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.494577	normal	fighting	0.755	t	Demo Camera	0.623	0.755	medium	1
05184f6d-9168-4078-8300-8be6b6f88930	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.494622	normal	fighting	0.755	t	Demo Camera	0.623	0.755	medium	1
a0d7c397-93fd-484c-9267-8bf13f50cf60	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.703143	normal	normal	0.752	f	Demo Camera	0.27	0.752	low	1
cd871270-1aba-4fd3-afe2-d851cc5fa4de	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.703179	normal	normal	0.752	f	Demo Camera	0.27	0.752	low	1
a09015e8-e476-4dae-83ad-5caa97459050	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.933826	normal	fighting	0.617	t	Demo Camera	0.617	0.388	medium	1
1736fbb2-90ee-4b47-ba56-c49765c2177e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.933867	normal	fighting	0.617	t	Demo Camera	0.617	0.388	medium	1
3e4d0a24-4f95-42ab-91ad-f6781c707c22	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.057423	normal	fighting	0.656	t	Demo Camera	0.238	0.656	medium	1
d49803e7-1547-420f-8376-487e45824ea9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.057462	normal	fighting	0.656	t	Demo Camera	0.238	0.656	medium	1
c8f9a5e0-c8cc-4a25-8e54-ef653d2b6c26	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.432392	normal	fighting	0.592	t	Demo Camera	0.397	0.592	medium	1
f2d89890-fea6-4310-8b08-6fa4d8959240	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.43243	normal	fighting	0.592	t	Demo Camera	0.397	0.592	medium	1
175cacc0-986e-4104-9a59-db341ac1c4a1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.672959	fighting	fighting	0.566	t	Demo Camera	0.4	0.492	medium	1
327b2db7-ddae-4b5f-805a-0edd7002f1dd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.673054	fighting	fighting	0.566	t	Demo Camera	0.4	0.492	medium	1
7a4250d5-71db-47ba-b510-7d72331f4062	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.812293	normal	normal	0.791	f	Demo Camera	0.417	0.791	low	1
d92bda74-4ed7-4a17-a142-05254336886b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.812346	normal	normal	0.791	f	Demo Camera	0.417	0.791	low	1
35b1f7d2-3626-4836-b74e-439aefee21f5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:48.564011	normal	normal	0.548	f	Demo Camera	0.391	0.548	low	1
3152f4b4-c0e8-45b6-b795-8b667dd70b35	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:48.564053	normal	normal	0.548	f	Demo Camera	0.391	0.548	low	1
0a0e9dd2-c3e2-4caf-9a49-6d7ccc2cc564	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:49.103939	normal	normal	0.718	f	Demo Camera	0.435	0.718	low	1
a4b00f92-a3e3-4b97-9ad3-8e09b4856cb4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:49.103977	normal	normal	0.718	f	Demo Camera	0.435	0.718	low	1
24b189a7-999e-493a-afae-c18d49ba8092	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:49.555232	forced_entry	normal	0.73	t	Demo Camera	0.73	0.678	high	1
6e834585-1428-4f96-8d6b-069c62de5e52	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:49.555311	forced_entry	normal	0.73	t	Demo Camera	0.73	0.678	high	1
25b24f4d-42da-4088-8e73-5bb54e773c77	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:52.585715	normal	normal	0.786	f	Demo Camera	0.4	0.786	low	1
bef0393c-2ada-4c59-9c1a-3acd30d34f34	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:52.585757	normal	normal	0.786	f	Demo Camera	0.4	0.786	low	1
ec9318de-f4be-458d-99cd-99f00fc636e0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:53.065124	normal	normal	0.702	f	Demo Camera	0.309	0.702	low	1
a3b4e64c-0137-49fc-bdbf-62fcb8dda551	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:53.065169	normal	normal	0.702	f	Demo Camera	0.309	0.702	low	1
fae6b91a-5372-4d2e-bc86-98994dc07b60	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:03.501135	normal	intruder_detected	0.867	t	Demo Camera	0.407	0.867	medium	1
a61d3f3f-1513-435e-9b6f-96707462a830	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:03.501215	normal	intruder_detected	0.867	t	Demo Camera	0.407	0.867	medium	1
6946b7d6-b963-4aa2-92ab-d96e81b30ea9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:03.729513	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
7b234c03-4b89-4e7c-ae8b-a158ee1cfca6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:03.729548	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
0db1c09b-a646-4add-9c26-db1f1bf47225	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:03.961591	normal	fighting	0.661	t	Demo Camera	0.263	0.661	medium	1
74b8a254-888c-46d0-bc0f-4133d2c7851d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:03.96163	normal	fighting	0.661	t	Demo Camera	0.263	0.661	medium	1
984f09ee-4f4a-4ca9-8251-4d83a0a613dc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.164528	normal	fighting	0.538	t	Demo Camera	0.345	0.538	medium	1
c386a7b4-d054-4b92-a835-ec47b77aca4d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.312866	normal	intruder_detected	0.519	t	Demo Camera	0.519	0.374	medium	1
323a67c8-3f08-47ff-a21a-d765a87b85a1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.312992	normal	intruder_detected	0.519	t	Demo Camera	0.519	0.374	medium	1
d80bc5bb-794e-4467-9d21-694320412f55	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.428201	normal	fighting	0.538	t	Demo Camera	0.345	0.538	medium	1
803a30da-eb9d-4f01-8bf0-a1762a361456	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.428238	normal	fighting	0.538	t	Demo Camera	0.345	0.538	medium	1
fdfdb0b0-8eeb-4432-9363-86ea77a54bb5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.655129	normal	fighting	0.764	t	Demo Camera	0.236	0.76	medium	1
0f15bab5-0773-4e5a-a703-ae46b040a3ac	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.655173	normal	fighting	0.764	t	Demo Camera	0.236	0.76	medium	1
0c54fb8f-f55e-470f-989c-d4b2101e1308	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:32.879854	normal	normal	0.76	f	Demo Camera	0.551	0.76	low	1
1dced488-428b-492e-bef2-60190ba29798	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:32.879893	normal	normal	0.76	f	Demo Camera	0.551	0.76	low	1
bf10f74d-e1ec-44e0-8427-9151cf2b54af	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.092387	normal	fighting	0.427	t	Demo Camera	0.242	0.427	medium	1
a61a0679-8234-4df8-a724-eb87707fefbb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.09243	normal	fighting	0.427	t	Demo Camera	0.242	0.427	medium	1
5ab13cf4-6ef2-43ce-9a69-828b4f869052	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.207286	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
92e0abf4-5cdc-48d4-94e3-e1d2f54b3346	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.207343	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
5809cf40-25fa-4048-b836-b33c9315c82a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.426869	normal	robbery	0.61	t	Demo Camera	0.61	0.445	high	1
bb1b88bd-5657-4a18-8afa-710d45be8c78	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.426952	normal	robbery	0.61	t	Demo Camera	0.61	0.445	high	1
44271aae-1f85-4f59-871c-6aa7904bb13e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.556467	normal	fighting	0.436	t	Demo Camera	0.35	0.436	medium	1
3956551a-4d26-4798-908f-b87dba1037f1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.556507	normal	fighting	0.436	t	Demo Camera	0.35	0.436	medium	1
af398736-3ff4-4f2b-8905-c85580d2c4af	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.761252	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
d8c127db-8230-43d3-9141-e5e6d7d4eb27	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.761289	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
6fc5a751-ef71-4bec-9fae-1b22ef01490a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:33.996841	normal	vehicle_intrusion	0.312	t	Demo Camera	0.239	0.312	medium	1
01364e4a-b992-4884-b628-956ce68d0140	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:33.996956	normal	vehicle_intrusion	0.312	t	Demo Camera	0.239	0.312	medium	1
a022cba0-460d-456f-80df-ddd1d1469f1f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.112645	normal	normal	0.752	f	Demo Camera	0.504	0.752	low	1
894756d8-b9c0-4bb3-90d8-3abc492f0e7d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.112681	normal	normal	0.752	f	Demo Camera	0.504	0.752	low	1
a17e0bb0-6049-4f71-a001-4eb4a45a5a3e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.367381	normal	fighting	0.786	t	Demo Camera	0.656	0.786	medium	1
9b3ebcbe-4f31-40f5-9969-a532cecb51b6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.36742	normal	fighting	0.786	t	Demo Camera	0.656	0.786	medium	1
dc6e6ffa-04f5-4f2a-99cc-60fc639c3451	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.60594	normal	normal	0.722	f	Demo Camera	0.391	0.722	low	1
9bb7e5b6-b860-45e2-ba48-b59e651f4ef7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.605977	normal	normal	0.722	f	Demo Camera	0.391	0.722	low	1
a53014d7-da2d-4e3f-9245-2d03c7d80fbe	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 07:58:34.735884	normal	normal	0.804	f	Demo Camera	0.196	0.802	low	1
7a22c0e7-c231-4e46-9fd4-938f1d3c6111	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 07:58:34.735932	normal	normal	0.804	f	Demo Camera	0.196	0.802	low	1
38986a0b-b9cd-4422-bfc2-9cd85ff721ad	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:48.713926	normal	normal	0.786	f	Demo Camera	0.4	0.786	low	1
b9b650b1-b2bf-41e1-a1de-943f6bc9f57b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:48.713964	normal	normal	0.786	f	Demo Camera	0.4	0.786	low	1
536f1fe5-9395-44a4-9315-e3cfb0206c32	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:15:49.200337	normal	normal	0.702	f	Demo Camera	0.309	0.702	low	1
9b49084d-40b8-4663-ba04-25ff54bf891f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:15:49.200376	normal	normal	0.702	f	Demo Camera	0.309	0.702	low	1
d02efb76-86e9-41a9-87f8-2a17a06568e3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:52.168336	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
ae39160b-f36c-4e7b-8f71-d9672b4abde3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:52.168377	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
08e58101-1a76-43da-a3cb-a8de43a48504	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:52.695763	normal	normal	0.407	f	Demo Camera	0.407	0.265	low	1
64272392-d7e4-4148-9031-f05b7fcb3af2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:52.695803	normal	normal	0.407	f	Demo Camera	0.407	0.265	low	1
e522ceb6-cc2f-4f89-bad6-07bf3cc00391	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:17:53.189803	normal	normal	0.665	f	Demo Camera	0.404	0.665	low	1
ef1edddf-3d30-4c44-9c8a-f45e3df7aa25	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:17:53.189842	normal	normal	0.665	f	Demo Camera	0.404	0.665	low	1
26d99f3b-3e74-4a6b-82b0-878b33fe27b6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:03.560111	normal	fighting	0.601	t	Demo Camera	0.601	0.497	medium	1
1edc5d09-99d7-4e0a-9999-c1dbe00b697b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:03.560184	normal	fighting	0.601	t	Demo Camera	0.601	0.497	medium	1
4d1fa3f2-577d-41b6-8570-816ba9fa5977	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:03.785387	normal	normal	0.757	f	Demo Camera	0.337	0.757	low	1
ef07f126-2774-4d6c-9549-33b6b5903062	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:03.785421	normal	normal	0.757	f	Demo Camera	0.337	0.757	low	1
38d5baf8-8865-4bd1-a75e-5494a2aea1c5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:04.017626	normal	fighting	0.758	t	Demo Camera	0.615	0.758	medium	1
ebe0d7d9-0c90-4103-81aa-3ded3e0d0505	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:29.703844	normal	normal	0.594	f	Demo Camera	0.404	0.594	low	1
804a387d-4831-48b4-a6b3-baa32dbd0b96	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:29.703879	normal	normal	0.594	f	Demo Camera	0.404	0.594	low	1
bd238d7f-f71f-4ddc-a014-0383028650b6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:50.122452	normal	normal	0.357	f	Demo Camera	0.357	0.329	low	1
ca42b737-d922-4fcf-a74f-b0cb62da3f05	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:50.122486	normal	normal	0.357	f	Demo Camera	0.357	0.329	low	1
2c51c3b9-ae21-498d-9613-566e097422ce	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:50.547848	normal	normal	0.723	f	Demo Camera	0.723	0.281	low	1
0257b020-4e47-4b58-98b6-a4621f43b8ca	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:50.547888	normal	normal	0.723	f	Demo Camera	0.723	0.281	low	1
84d51982-bf01-4dcc-8696-c6c8c85d59db	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:50.985303	normal	normal	0.679	f	Demo Camera	0.679	0.247	low	1
f04b71b3-16a7-47bc-9af9-ac99fcaab2e4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:50.985337	normal	normal	0.679	f	Demo Camera	0.679	0.247	low	1
1398bc3b-5653-4ee1-bbe8-b4f63ba1d5cd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:24.290457	normal	normal	0.734	f	Demo Camera	0.571	0.734	low	1
d0503d33-fa43-47ac-a629-55c054fa29a5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:24.290491	normal	normal	0.734	f	Demo Camera	0.571	0.734	low	1
aecec54c-338e-47ab-9505-54dd8eed5953	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:26.728303	normal	normal	0.753	f	Demo Camera	0.734	0.753	low	1
efa4a292-0dff-479c-8bc5-2a8062b30a3e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:26.728337	normal	normal	0.753	f	Demo Camera	0.734	0.753	low	1
a743dde8-75b7-40f6-ac2f-d1512bf33d30	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:29.139667	normal	normal	0.67	f	Demo Camera	0.67	0.278	low	1
1225d090-78a1-4d6e-ba14-6cd66873f1d9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:29.139707	normal	normal	0.67	f	Demo Camera	0.67	0.278	low	1
f607afbe-854c-46d6-9179-d02ed0ff813c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:46.35444	normal	abuse	0.651	t	Demo Camera	0.651	0.482	high	1
bea124e1-42b5-4536-9484-06737bc53074	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:46.354485	normal	abuse	0.651	t	Demo Camera	0.651	0.482	high	1
37df9ae4-c9dc-4b0d-ba3e-1880f8034174	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:47.62385	normal	normal	0.639	f	Demo Camera	0.745	0.639	low	1
3ffb251c-1b15-45f1-b2a5-76b15d738da3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:47.623883	normal	normal	0.639	f	Demo Camera	0.745	0.639	low	1
ebd7f095-094d-4b7f-8d1d-31a77d95f231	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:04.497056	normal	intruder_detected	0.486	t	Demo Camera	0.475	0.486	medium	1
ff2cff36-45f6-4af0-8a84-531d37f6128d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:04.497092	normal	intruder_detected	0.486	t	Demo Camera	0.475	0.486	medium	1
8961652c-ddff-4158-8045-d111a85cba76	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:05.493066	normal	fighting	0.68	t	Demo Camera	0.446	0.68	medium	1
5e2631b8-e4fb-442d-87d0-8bb988f2793a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:05.493108	normal	fighting	0.68	t	Demo Camera	0.446	0.68	medium	1
d515ba93-fb04-4a6b-b294-12f8f49c7428	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:06.469646	normal	intruder_detected	0.641	t	Demo Camera	0.295	0.641	medium	1
cf1543ac-b39b-4720-acdf-52678e84894c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:06.469682	normal	intruder_detected	0.641	t	Demo Camera	0.295	0.641	medium	1
b2a89b45-64b3-44e8-8df7-1bf82f9cf08c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:07.450034	normal	normal	0.739	f	Demo Camera	0.487	0.739	low	1
ca984b0d-2d31-43ca-9780-c8c496e367cb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:07.450073	normal	normal	0.739	f	Demo Camera	0.487	0.739	low	1
f2eef866-6173-4fbf-b629-47991ed7f486	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:08.443014	normal	fighting	0.689	t	Demo Camera	0.572	0.689	medium	1
e6017c13-e0e8-4ca6-a948-a1d7baeffc1a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:08.443048	normal	fighting	0.689	t	Demo Camera	0.572	0.689	medium	1
61b25e17-3106-4a5d-9d71-a8aa8d8449ff	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:15.880112	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
57b63aaa-5348-45d0-a1f6-5030cd63919d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:15.880204	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
5ddd108f-714c-4489-babd-fb1359cd0bc7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:21.582868	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
4ad92f27-0f2b-4845-b95d-bcaa3f3e2777	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:21.582907	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
18e9bb91-61a8-4b7a-8cf4-59593a242fd1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:23.971409	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
f005522a-39a2-491f-92c0-a4d95c8d5040	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:23.971447	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
3ff54b3e-9997-49f7-b173-9604cda7d8d5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:41.311724	normal	normal	0.782	f	Demo Camera	0.233	0.782	low	1
d2523f51-dd37-4c80-b773-f78863a7f1d8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:42.902585	normal	violence	0.963	t	Demo Camera	0.443	0.963	high	1
f699288f-74fd-498e-9356-43cb06c48bd6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:42.902801	normal	violence	0.963	t	Demo Camera	0.443	0.963	high	1
e1de1b84-4a40-4100-afae-42160b4e1c79	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:44.479792	normal	normal	0.785	f	Demo Camera	0.215	0.509	low	1
d4016d55-0574-4ee6-af6d-9cb2a57f342a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:44.48	normal	normal	0.785	f	Demo Camera	0.215	0.509	low	1
9b669192-2b69-426f-ac40-7cb83e726e88	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:46.067508	normal	normal	0.819	f	Demo Camera	0.181	0.775	low	1
10eb8bd4-a569-446b-80d9-3b46d1112d77	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:46.067712	normal	normal	0.819	f	Demo Camera	0.181	0.775	low	1
91a32ae8-8ad3-45ed-8dc6-107a40b697f1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:47.635993	normal	normal	0.762	f	Demo Camera	0.386	0.762	low	1
0405eb83-7f21-4912-9228-804bf1c22819	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:47.636164	normal	normal	0.762	f	Demo Camera	0.386	0.762	low	1
94d953c4-2d36-4008-a0a5-a207fc23a8b2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:49.196562	normal	violence	0.986	t	Demo Camera	0.4	0.986	high	1
7b50e375-b2e8-44d1-9f14-9adf68e85a1b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:29.760201	normal	normal	0.817	f	Demo Camera	0.594	0.817	low	1
240d111e-469b-4554-91b7-9d524b4e74ea	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:29.760234	normal	normal	0.817	f	Demo Camera	0.594	0.817	low	1
6fd6ec77-9829-4ef1-bd8b-0a01457a9d95	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:50.244026	normal	normal	0.732	f	Demo Camera	0.571	0.732	low	1
bf65897b-0ba8-4d6b-a37a-dcb7a6aed7a5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:50.244066	normal	normal	0.732	f	Demo Camera	0.571	0.732	low	1
85a6a906-904d-4d9b-a15f-230b8b280955	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:50.667836	normal	normal	0.734	f	Demo Camera	0.734	0.248	low	1
80816ce8-0e14-4425-bbc9-a44b1c59e83c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:50.667875	normal	normal	0.734	f	Demo Camera	0.734	0.248	low	1
acde8b42-4d37-42f9-83f1-2e9260b94613	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:51.106437	normal	normal	0.67	f	Demo Camera	0.67	0.274	low	1
11a791a0-abc5-4b52-9791-162645c4e59b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:51.106478	normal	normal	0.67	f	Demo Camera	0.67	0.274	low	1
fad2499f-c58a-49fb-82fe-e92fa3953912	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:24.852732	normal	normal	0.746	f	Demo Camera	0.386	0.746	low	1
77ac46e7-7923-4a61-986b-b05c33cebef4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:24.852765	normal	normal	0.746	f	Demo Camera	0.386	0.746	low	1
822a7d7d-bde6-401e-9395-b00fedab8a21	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:27.28111	normal	normal	0.667	f	Demo Camera	0.667	0.289	low	1
48af2c73-db14-4195-bace-af2868f96a6c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:27.281154	normal	normal	0.667	f	Demo Camera	0.667	0.289	low	1
c88bac7d-4596-43fd-bb0e-7265785cfa9d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:29.801091	normal	normal	0.637	f	Demo Camera	0.637	0.271	low	1
55885238-0990-4687-b15e-6b029295b804	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:29.801128	normal	normal	0.637	f	Demo Camera	0.637	0.271	low	1
71d85462-1398-4231-9833-4ee0f75eb3b0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:46.655719	normal	normal	0.767	f	Demo Camera	0.404	0.767	low	1
a4ac78e2-8623-4069-9c8e-5deeff1d8635	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:46.65576	normal	normal	0.767	f	Demo Camera	0.404	0.767	low	1
6e25c652-6835-457a-8fb6-9962b92d29f6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:03.766784	normal	intruder_detected	0.867	t	Demo Camera	0.407	0.867	medium	1
f7d99bc2-1957-4adf-bcc0-43b802f249ab	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:03.766856	normal	intruder_detected	0.867	t	Demo Camera	0.407	0.867	medium	1
4bab664c-c8f1-448a-898d-13a50b49829e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:04.764104	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
a9992edd-5d42-469f-8aa9-878a6e2888d4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:04.764144	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
e2a188ca-103b-41a0-8973-5d6a002371ee	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:05.742758	normal	fighting	0.783	t	Demo Camera	0.263	0.783	medium	1
08d3fa5a-d680-4c53-ad39-5e1ad66fc04b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:05.742797	normal	fighting	0.783	t	Demo Camera	0.263	0.783	medium	1
b7a704fe-f0fa-473b-a9d0-a0d181d94f90	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:06.705455	normal	fighting	0.655	t	Demo Camera	0.345	0.655	medium	1
7a4790cc-b2a4-4ae5-bcc0-ac66af068740	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:06.705491	normal	fighting	0.655	t	Demo Camera	0.345	0.655	medium	1
8300573c-7dc3-448d-b95b-c36390f83c72	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:07.695923	normal	fighting	0.76	t	Demo Camera	0.353	0.76	medium	1
5dbe412e-0618-4d0e-9e1a-a92b8a268b0a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:07.695961	normal	fighting	0.76	t	Demo Camera	0.353	0.76	medium	1
38f156f3-42f1-4b4e-a7e9-07de34059b46	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:16.749258	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
7f15d35d-2d76-4b43-988d-036777a5c79e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:16.749299	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
639cccfc-a463-4511-802b-8e99dae13d85	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:18.367012	distress_sounds	weapon_detected	0.375	t	Demo Camera	0.441	0.789	high	1
f66331d6-6583-4440-b53c-04b0344f9854	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:18.367123	distress_sounds	weapon_detected	0.375	t	Demo Camera	0.441	0.789	high	1
13cd0177-1bed-46e7-9243-c71ed4c5b598	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:19.146655	distress_sounds	weapon_detected	0.655	t	Demo Camera	0.771	0.773	high	1
b61f5dfc-986b-4136-8de5-a8bc0cd01422	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:19.146701	distress_sounds	weapon_detected	0.655	t	Demo Camera	0.771	0.773	high	1
60de4dc7-50f2-4aab-96e0-9ea6670b1198	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:42.498138	normal	violence	0.99	t	Demo Camera	0.186	0.99	high	1
232b2393-2ba6-41a9-a41f-f92fdeab606e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:42.498347	normal	violence	0.99	t	Demo Camera	0.186	0.99	high	1
a15f2023-9d97-4cb8-9411-8bf8ef6dd38f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:44.08413	normal	violence	0.99	t	Demo Camera	0.196	0.99	high	1
1b648514-aa93-4903-abd6-ca2faa51fcd8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:44.084269	normal	violence	0.99	t	Demo Camera	0.196	0.99	high	1
b75acdbf-a76c-433c-bc21-165a7e9a523a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:47.24793	normal	violence	0.99	t	Demo Camera	0.38	0.99	high	1
ff23089b-7af9-414e-baa8-0c83c5b30dd8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:47.248077	normal	violence	0.99	t	Demo Camera	0.38	0.99	high	1
5a342bca-eb93-4e34-8012-f9e8af186ff9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:48.813631	normal	violence	0.99	t	Demo Camera	0.283	0.99	high	1
e3d6f189-d118-4599-a39f-967fb9f2b6c7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:48.813843	normal	violence	0.99	t	Demo Camera	0.283	0.99	high	1
db9264ac-106c-47cf-b505-a9feb0635e97	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:50.395394	normal	violence	0.851	t	Demo Camera	0.229	0.851	high	1
9361d41f-d17f-41c4-b69b-42874dce3aa6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:50.395557	normal	violence	0.851	t	Demo Camera	0.229	0.851	high	1
de8211ad-07c2-4271-9146-92ad0347e879	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:51.956075	normal	violence	0.936	t	Demo Camera	0.329	0.936	high	1
884861de-32ae-4ab2-9042-a87679ea3d78	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:29.832591	normal	normal	0.616	f	Demo Camera	0.543	0.616	low	1
91b24b8c-e05e-4a2c-b88c-23e4c6e5816d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:29.832625	normal	normal	0.616	f	Demo Camera	0.543	0.616	low	1
f4911c7d-1126-4a65-8da1-aaa97ceabf00	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:50.33535	normal	normal	0.742	f	Demo Camera	0.386	0.742	low	1
356c31d0-ad44-4305-8a0c-072fb28feaf0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:50.335392	normal	normal	0.742	f	Demo Camera	0.386	0.742	low	1
1c7a2e65-cd8c-4666-89fd-a3ee4b9dcc58	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:50.759142	normal	normal	0.667	f	Demo Camera	0.667	0.289	low	1
020e7313-dcbc-4553-852c-6ee1fe6010b2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:50.759181	normal	normal	0.667	f	Demo Camera	0.667	0.289	low	1
a144aa61-927d-4ee9-bd6c-ab28ae79b1be	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:51.23599	normal	normal	0.637	f	Demo Camera	0.637	0.267	low	1
48503e95-268e-49bb-8fac-e7d4d4ea6190	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:51.236027	normal	normal	0.637	f	Demo Camera	0.637	0.267	low	1
e9add5db-d646-469c-9e7d-a44df2a60c49	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:25.511963	normal	normal	0.756	f	Demo Camera	0.724	0.756	low	1
f3eb4db2-0a21-4b3f-ba07-330b11cb2f0f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:25.512002	normal	normal	0.756	f	Demo Camera	0.724	0.756	low	1
b4f94189-15b9-4f50-b2d2-6b276afe7342	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:27.928754	normal	normal	0.748	f	Demo Camera	0.681	0.748	low	1
c2cefdc0-4d13-4f45-acf1-c412ae9baeae	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:27.928793	normal	normal	0.748	f	Demo Camera	0.681	0.748	low	1
25135017-c03c-42fb-99b2-96fab28d3cee	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:45.736003	normal	normal	0.814	f	Demo Camera	0.874	0.814	low	1
09ef8bd8-e222-49af-85b2-bba3bb3dabb0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:45.736042	normal	normal	0.814	f	Demo Camera	0.874	0.814	low	1
cedd4495-fa0a-42ab-b209-fbc00f503de8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:46.9201	normal	normal	0.817	f	Demo Camera	0.594	0.817	low	1
98f3af30-c9f1-4b87-8f54-5e6b6a3a0dce	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:46.920138	normal	normal	0.817	f	Demo Camera	0.594	0.817	low	1
84a795cd-6733-41cc-8a32-f314bb1c8189	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:04.028316	normal	fighting	0.646	t	Demo Camera	0.601	0.646	medium	1
1d0db771-c73a-4c14-a6f7-37398f70fb8f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:04.028393	normal	fighting	0.646	t	Demo Camera	0.601	0.646	medium	1
e49c5036-9ad3-45c6-a26c-0bd2c2d70ebc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:05.008266	normal	normal	0.84	f	Demo Camera	0.337	0.84	low	1
3996c8b3-fd60-4a3b-afe8-90c73d87f14d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:05.008304	normal	normal	0.84	f	Demo Camera	0.337	0.84	low	1
536100bb-a5c0-41f8-927e-d2601f7bfdd3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:05.993492	normal	fighting	0.783	t	Demo Camera	0.615	0.783	medium	1
4b1d4cec-0644-47e3-93c6-36e81f3f9d33	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:05.993526	normal	fighting	0.783	t	Demo Camera	0.615	0.783	medium	1
2c0c301d-6e5d-4d5b-944c-486f56da4ace	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:06.954311	normal	fighting	0.63	t	Demo Camera	0.452	0.63	medium	1
328b35b5-708d-456d-bcb3-0e62024d9c80	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:06.954352	normal	fighting	0.63	t	Demo Camera	0.452	0.63	medium	1
f7974998-dbf0-49bd-814c-2bd44f1f71b1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:07.93509	normal	intruder_detected	0.779	t	Demo Camera	0.49	0.779	medium	1
51331458-ee29-4a97-8b00-aa3c34ca0196	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:07.935126	normal	intruder_detected	0.779	t	Demo Camera	0.49	0.779	medium	1
15a53570-6728-4891-9afa-f6d09fbe2d75	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:17.506437	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
acd40f33-6a9f-4e58-a8aa-3d21601579e9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:17.506487	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
3a105b90-dc66-424e-9c71-fafee5cf23c7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:22.333746	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
90196111-3b68-4cda-b229-6cb501087961	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:22.333789	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
248da1e1-8627-4436-9991-0ea9631913c6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:46.465067	normal	violence	0.99	t	Demo Camera	0.191	0.99	high	1
ea01abe9-7518-4bd0-aa69-d3a5dc7b2d91	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:46.465271	normal	violence	0.99	t	Demo Camera	0.191	0.99	high	1
3aa5e765-437d-4ddd-8d5e-5dc16ada8112	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:48.035054	normal	normal	0.517	f	Demo Camera	0.373	0.483	low	1
eeab4dd9-60e9-41cc-a056-ce962db957a7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:48.035248	normal	normal	0.517	f	Demo Camera	0.373	0.483	low	1
f2aa2edd-4fd7-4f5e-bbcb-1323e2e9478f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:49.586419	normal	normal	0.802	f	Demo Camera	0.533	0.802	low	1
0d38c6ec-c01d-4067-a705-33bc93bf366d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:49.586577	normal	normal	0.802	f	Demo Camera	0.533	0.802	low	1
5d1d276d-6bb5-4b3a-adfa-c95b45404cb1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:51.178313	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
28881cf3-ade6-44f0-a2bf-5c09037ee595	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:51.178486	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
9c743240-10f0-402f-9550-295499dd88b5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:52.726636	normal	violence	0.99	t	Demo Camera	0.182	0.99	high	1
4d180281-a0de-4f3c-9510-36c35229eb9c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:52.726843	normal	violence	0.99	t	Demo Camera	0.182	0.99	high	1
28d7008b-f4a9-40c9-80cf-22505bc482f3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:55.898567	normal	violence	0.99	t	Demo Camera	0.531	0.99	high	1
196a3eb0-ea52-4578-8641-27547ab37d74	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:55.898722	normal	violence	0.99	t	Demo Camera	0.531	0.99	high	1
2e840ad0-6bbf-4d27-915a-0f2b28bc6587	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:57.487814	normal	violence	0.99	t	Demo Camera	0.29	0.99	high	1
e6c5ca9a-4a46-4075-9d4b-6c2c98a91a1f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:57.488016	normal	violence	0.99	t	Demo Camera	0.29	0.99	high	1
730105ee-1390-4651-952d-ebff4a7630cf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:29.909689	normal	normal	0.61	f	Demo Camera	0.745	0.61	low	1
1877f64b-e5a6-4e79-a7ad-c47541607eed	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:29.909724	normal	normal	0.61	f	Demo Camera	0.745	0.61	low	1
f880c23b-8ad1-41e9-add9-e920fa2a33e1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:50.45436	normal	normal	0.724	f	Demo Camera	0.724	0.316	low	1
caf7a109-c771-4543-a345-59ee2f155f0a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:50.454397	normal	normal	0.724	f	Demo Camera	0.724	0.316	low	1
13e605b0-781e-43b4-98c5-2039a9dcaa57	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:18:50.888981	normal	normal	0.681	f	Demo Camera	0.681	0.268	low	1
387515a0-d9cd-4f65-b0e2-a50508f58419	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:18:50.889019	normal	normal	0.681	f	Demo Camera	0.681	0.268	low	1
df50c382-04fa-4e3e-9f81-0172fe3a2c7b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:23.60846	normal	normal	0.763	f	Demo Camera	0.357	0.763	low	1
a6633fe5-ed9e-4cf3-be6c-655e7694cd54	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:23.608503	normal	normal	0.763	f	Demo Camera	0.357	0.763	low	1
486f989e-f181-4991-8ad1-e83ab47e0e8b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:26.068706	normal	normal	0.757	f	Demo Camera	0.723	0.757	low	1
6b58d014-d49e-48f9-870b-b48d049b5a74	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:26.068746	normal	normal	0.757	f	Demo Camera	0.723	0.757	low	1
69ffaf8d-93b9-492d-97c1-4cccd609c5de	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:28.500656	normal	normal	0.748	f	Demo Camera	0.679	0.748	low	1
8a9fddbc-d95a-4058-885a-3f7779cc5e3a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:28.500694	normal	normal	0.748	f	Demo Camera	0.679	0.748	low	1
04e6dc28-e719-4e7f-b2fa-20b93d3189b7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:46.07108	normal	abuse	0.729	t	Demo Camera	0.372	0.729	high	1
c6ef4ae5-6c7b-438a-a53f-8ec61fbe0c00	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:46.07115	normal	abuse	0.729	t	Demo Camera	0.372	0.729	high	1
c4b05154-7287-4b03-99f0-62b325428c5b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:22:47.299295	normal	normal	0.684	f	Demo Camera	0.543	0.684	low	1
13ae42bb-8bd0-406d-bdd2-5b3cddf7ecf5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:22:47.299329	normal	normal	0.684	f	Demo Camera	0.543	0.684	low	1
6c392170-d1c7-4eb9-9a12-264a2d1d952f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:04.259256	fighting	fighting	0.826	t	Demo Camera	0.481	0.718	medium	1
fa9479b7-b393-4162-9b11-5693e07a3060	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:04.259331	fighting	fighting	0.826	t	Demo Camera	0.481	0.718	medium	1
9c42d23e-b021-4456-b7b5-a441e320dc40	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:05.262187	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
ed26dc7f-a9b7-4b15-8af0-dcf850604a23	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:05.262221	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
a27e95eb-2729-4153-aa80-2e9c9c422f1e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:06.226264	normal	normal	0.743	f	Demo Camera	0.519	0.743	low	1
1860a288-128a-4eed-96a8-ecb1fadb55b1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:06.226298	normal	normal	0.743	f	Demo Camera	0.519	0.743	low	1
e55d29e2-e3c9-47ed-8e3d-7a2875c8d354	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:07.209731	normal	robbery	0.533	t	Demo Camera	0.533	0.476	high	1
9898b33c-e43a-4a94-84e1-4b57d945acad	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:07.209811	normal	robbery	0.533	t	Demo Camera	0.533	0.476	high	1
776eefe8-01e0-40ef-9ba7-767ac2969ad7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:08.185329	normal	fighting	0.932	t	Demo Camera	0.369	0.932	medium	1
99737caf-870c-484a-9b0c-6ce933ff6dce	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:08.185365	normal	fighting	0.932	t	Demo Camera	0.369	0.932	medium	1
61a8d52e-994d-4822-8d69-0385bbfc3ed3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:08.70519	normal	fighting	0.551	t	Demo Camera	0.551	0.482	medium	1
e73f77c5-6989-4139-bab6-abf83f66fc77	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:08.705229	normal	fighting	0.551	t	Demo Camera	0.551	0.482	medium	1
4d14a31d-c780-437a-a243-62f3f8d93458	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:08.936459	normal	fighting	0.773	t	Demo Camera	0.677	0.773	medium	1
cb43fe86-774a-457c-82df-35f38c75dfc1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:08.9365	normal	fighting	0.773	t	Demo Camera	0.677	0.773	medium	1
e075612c-4016-49e0-a6bc-113d3481f7e5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:09.177656	normal	fighting	0.728	t	Demo Camera	0.375	0.728	medium	1
80f6dd55-ca27-4a5e-a336-b0dfa4e28326	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:09.17769	normal	fighting	0.728	t	Demo Camera	0.375	0.728	medium	1
a76770aa-6d30-4f31-a50a-6d3309dc8895	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:09.414993	normal	fighting	0.73	t	Demo Camera	0.73	0.617	medium	1
73a1625a-48e1-434f-91e7-44b781122822	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:09.415032	normal	fighting	0.73	t	Demo Camera	0.73	0.617	medium	1
ab0e0e48-f7a2-44bc-95ed-5007a31b4f3b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:09.69239	normal	fighting	0.663	t	Demo Camera	0.242	0.663	medium	1
d1185552-759b-4d48-ac11-f28826b4a0f5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:09.692429	normal	fighting	0.663	t	Demo Camera	0.242	0.663	medium	1
31d236f6-3443-41f7-aa28-dcfc628b32db	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:09.949374	normal	normal	0.831	f	Demo Camera	0.53	0.831	low	1
70712b0b-3235-4b36-8311-9d345f4d99ec	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:09.949415	normal	normal	0.831	f	Demo Camera	0.53	0.831	low	1
3ef2d667-9332-4f02-ba6b-97683204d2bb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:10.18591	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
1e7da19d-154f-4535-b1cb-c0edbbfacdc6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:10.185954	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
e768bba9-a351-42f0-8298-2f23db8bcd68	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:10.429697	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
2e781540-a57e-4df6-bd81-a6d87f268b35	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:10.429732	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
775882da-f7c6-4c41-959a-a2697e264e92	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:10.670056	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
9090ba7d-ec0f-48fe-a4b6-f006897ef250	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:10.670095	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
7b69dca7-81bd-40cf-b67a-5b263fddc37a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:10.920795	normal	fighting	0.713	t	Demo Camera	0.473	0.713	medium	1
a4d8b2b8-d53a-41e6-8896-170ee49b96eb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:10.920834	normal	fighting	0.713	t	Demo Camera	0.473	0.713	medium	1
8ec395f6-5526-48e8-9377-1671162f2d0f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:11.867775	normal	fighting	0.792	t	Demo Camera	0.627	0.792	medium	1
7e3f50f7-0cdb-47ce-b459-5aab8c25e44d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:11.867813	normal	fighting	0.792	t	Demo Camera	0.627	0.792	medium	1
cdd91039-a315-4fd0-9184-a3c205545607	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:12.85806	normal	fighting	0.682	t	Demo Camera	0.237	0.682	medium	1
6161ac71-89b6-4600-b226-9c30681ffc3b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:12.8581	normal	fighting	0.682	t	Demo Camera	0.237	0.682	medium	1
ff224bb9-ea0e-490d-b42b-ee3247db36cb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:13.820728	normal	fighting	0.86	t	Demo Camera	0.238	0.86	medium	1
9b1b0c8a-7b3c-4de2-82ce-16efc9055680	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:13.820768	normal	fighting	0.86	t	Demo Camera	0.238	0.86	medium	1
06944a78-6e1c-4f60-844b-d8e85a2b4246	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:14.76747	normal	fighting	0.585	t	Demo Camera	0.569	0.585	medium	1
48c4ad35-ff1a-426f-8745-e0f0a1242f2e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:14.767511	normal	fighting	0.585	t	Demo Camera	0.569	0.585	medium	1
0d1444b8-736f-4f91-b184-b83235067fc8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:15.764928	normal	forced_entry	0.677	t	Demo Camera	0.652	0.677	high	1
b5aa0128-74be-4397-8a55-ee5a125203ee	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:15.764967	normal	forced_entry	0.677	t	Demo Camera	0.652	0.677	high	1
944361a1-a657-4948-8428-bde5a07c8373	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:16.936688	normal	normal	0.802	f	Demo Camera	0.495	0.802	low	1
f9874d2e-a25c-4b02-b739-5c85a7fb82e1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:16.93673	normal	normal	0.802	f	Demo Camera	0.495	0.802	low	1
a40f9150-a13c-438d-abcc-1f0fe4b8d175	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:23.677008	normal	intruder_detected	0.867	t	Demo Camera	0.407	0.867	medium	1
c09bbcd1-24cf-4054-8cdf-fdfb530e3b52	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:23.677085	normal	intruder_detected	0.867	t	Demo Camera	0.407	0.867	medium	1
606c72ad-1a72-4c05-95b2-024fe7d3e22e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:24.640316	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
10742028-6068-4a83-8a4f-6a2963d46d52	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:24.640356	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
744a03aa-c8ae-404e-86ec-89aee752e848	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:25.6325	normal	robbery	0.438	t	Demo Camera	0.263	0.438	high	1
30ed3607-f57a-40b0-8583-3d849941b02e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:25.632572	normal	robbery	0.438	t	Demo Camera	0.263	0.438	high	1
a6a4ec7b-29b7-43bc-ae7f-24f8d8cc0e1e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:26.58593	normal	fighting	0.655	t	Demo Camera	0.345	0.655	medium	1
77ac6f68-f19d-4189-84b4-61928adca540	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:26.585972	normal	fighting	0.655	t	Demo Camera	0.345	0.655	medium	1
64cb9afa-1127-478d-b394-dbf6d568e89f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:27.580069	normal	abuse	0.353	t	Demo Camera	0.353	0.339	high	1
947fdff8-18ee-45aa-a852-11137df03486	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:27.580142	normal	abuse	0.353	t	Demo Camera	0.353	0.339	high	1
c76b8df6-8b4a-4b93-90db-86e5513ac5f2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:28.553903	normal	abuse	0.551	t	Demo Camera	0.551	0.357	high	1
ec71475a-d170-46e9-bd8b-50ca687708e3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:28.553945	normal	abuse	0.551	t	Demo Camera	0.551	0.357	high	1
ad684b3a-69d0-486b-8e8c-cde62bc7f668	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:29.545474	normal	fighting	0.663	t	Demo Camera	0.242	0.663	medium	1
1e15e943-6cca-45eb-927d-4bab91e90cfd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:29.545508	normal	fighting	0.663	t	Demo Camera	0.242	0.663	medium	1
96abd2aa-9635-4b5d-b730-aa3112833f89	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:30.510008	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
e804a1cc-02f2-49b8-8fa3-ff3a181bc130	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:30.510042	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
dfc22c8d-2175-4608-802a-cab2ba94106e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:31.45922	normal	robbery	0.35	t	Demo Camera	0.35	0.348	high	1
43946024-e8ae-4e7d-adf2-47ff9c5c639d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:31.459258	normal	robbery	0.35	t	Demo Camera	0.35	0.348	high	1
0db2f97f-239d-4474-abda-0037481b5a5a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:32.427007	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
c02243cf-e68f-456d-b7f3-97fc3b7758a1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:32.427042	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
411c104e-e3b3-43fa-bae7-0b467f810829	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:33.437288	normal	fighting	0.86	t	Demo Camera	0.239	0.86	medium	1
2b2d15d5-0f97-43e6-aeb3-62f71b96cbac	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:33.437327	normal	fighting	0.86	t	Demo Camera	0.239	0.86	medium	1
6852440c-1940-43cb-9202-55aa02e7a841	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:34.371891	normal	weapon_detected	0.522	t	Demo Camera	0.522	0.503	high	1
39b87329-a693-45ab-90eb-0a094790cbd7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:34.371959	normal	weapon_detected	0.522	t	Demo Camera	0.522	0.503	high	1
b9dba4f1-1c7e-4992-a2a8-d2d48e3e5ec4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:35.346722	normal	forced_entry	0.677	t	Demo Camera	0.397	0.677	high	1
92ce5f30-9f7a-43c8-aa7c-6c0a1dd2d466	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:35.346763	normal	forced_entry	0.677	t	Demo Camera	0.397	0.677	high	1
2caeba88-4269-49a2-82c2-155256b9deba	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:36.439876	normal	fighting	0.6	t	Demo Camera	0.6	0.599	medium	1
f84fc748-26a2-4ea8-b2c4-f4e8003ae6c8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:36.439917	normal	fighting	0.6	t	Demo Camera	0.6	0.599	medium	1
a25842d3-d095-4795-862f-b0338534f7e0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:37.720772	normal	normal	0.44	f	Demo Camera	0.328	0.44	low	1
de04ce39-1772-4a88-947b-0c47848cc65a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:11.15839	normal	fighting	0.789	t	Demo Camera	0.61	0.789	medium	1
682d419e-99af-4dc2-8f6b-f606f7b33cf1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:11.158429	normal	fighting	0.789	t	Demo Camera	0.61	0.789	medium	1
e67084e2-2f81-4a04-a874-6fb8509d40f6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:12.102133	normal	forced_entry	0.615	t	Demo Camera	0.424	0.615	high	1
12ed4997-6f65-4495-bd2e-d777f9f3610a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:12.102214	normal	forced_entry	0.615	t	Demo Camera	0.424	0.615	high	1
54d0c609-27a4-48ec-a51a-fec766c896ef	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:13.098226	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
b0e98732-5858-4e27-9086-5a1ca6b29f90	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:13.098267	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
1804ea80-e678-4229-b1e0-dce725040bc2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:14.067916	normal	normal	0.752	f	Demo Camera	0.504	0.752	low	1
80a1a99b-a17d-48dd-8206-adfff59d9788	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:14.067956	normal	normal	0.752	f	Demo Camera	0.504	0.752	low	1
6e578c04-11be-4919-8e56-321dbf95f7bd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:14.999283	normal	fighting	0.69	t	Demo Camera	0.274	0.69	medium	1
d18a48ff-d18c-40c0-842a-aabc66e6a874	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:14.999323	normal	fighting	0.69	t	Demo Camera	0.274	0.69	medium	1
186e8990-538b-41e0-9866-77691364c01e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:16.035052	normal	fighting	0.765	t	Demo Camera	0.765	0.703	medium	1
7e14048d-b681-4b19-8820-92c4290703cc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:16.035094	normal	fighting	0.765	t	Demo Camera	0.765	0.703	medium	1
abc88524-f53b-4cd6-a9a8-81d1aa4dbac8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:17.275235	normal	normal	0.821	f	Demo Camera	0.417	0.821	low	1
8b4083ad-4128-477a-9334-49c1604adc89	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:17.275276	normal	normal	0.821	f	Demo Camera	0.417	0.821	low	1
0df2a9e6-410c-4caf-8975-9b653c35f0b5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:23.924932	normal	fighting	0.646	t	Demo Camera	0.601	0.646	medium	1
95bfee86-f427-4ba3-89c0-0a9545f5a6f9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:23.925001	normal	fighting	0.646	t	Demo Camera	0.601	0.646	medium	1
db8eaa43-39ad-4920-9715-b80f2b6900bb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:24.894859	normal	normal	0.84	f	Demo Camera	0.337	0.84	low	1
1efb1623-9b24-4042-8781-337920d1ae4e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:24.8949	normal	normal	0.84	f	Demo Camera	0.337	0.84	low	1
5d1cc30c-fdeb-4e52-97d6-cf5b16786471	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:25.884299	normal	fighting	0.783	t	Demo Camera	0.615	0.783	medium	1
b8fc8ea9-2183-42bd-ab03-3c9da9548014	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:25.884334	normal	fighting	0.783	t	Demo Camera	0.615	0.783	medium	1
30a94396-18f6-4473-ad24-8d4bb103a9d1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:26.832746	normal	fighting	0.63	t	Demo Camera	0.452	0.63	medium	1
f1e14721-07f9-4e7d-8dcc-f784d18311d9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:26.832784	normal	fighting	0.63	t	Demo Camera	0.452	0.63	medium	1
9d877bb9-2b13-4646-97ac-7cf1761edde1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:27.836717	normal	intruder_detected	0.779	t	Demo Camera	0.49	0.779	medium	1
de4af381-b671-428b-9075-87efc76aa76c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:27.836756	normal	intruder_detected	0.779	t	Demo Camera	0.49	0.779	medium	1
706f4fdb-a91c-4a0d-91f1-fce1cc541688	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:28.788019	normal	abuse	0.677	t	Demo Camera	0.677	0.357	high	1
951cdda7-5a30-483c-81e6-d7e31d2875ca	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:28.788057	normal	abuse	0.677	t	Demo Camera	0.677	0.357	high	1
7f67ad68-3ec7-4fd8-b733-d43c0bb55bf8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:29.799592	normal	forced_entry	0.53	t	Demo Camera	0.53	0.38	high	1
cff9f379-3890-4d44-bad8-966a91d88bf4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:29.799635	normal	forced_entry	0.53	t	Demo Camera	0.53	0.38	high	1
18f891f9-9532-482f-97dd-878fed695ff5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:30.737159	normal	fighting	0.713	t	Demo Camera	0.473	0.713	medium	1
c647dc4c-8dc7-47e9-8768-2697425ab9fa	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:30.737192	normal	fighting	0.713	t	Demo Camera	0.473	0.713	medium	1
a97e5802-b523-45e0-8ba3-42d64523c8fd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:31.692414	normal	fighting	0.792	t	Demo Camera	0.627	0.792	medium	1
8e360826-b4f2-4944-bab6-a279845217a7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:31.692447	normal	fighting	0.792	t	Demo Camera	0.627	0.792	medium	1
3dd84a3f-671f-4f14-80d8-89d1ce678441	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:32.688439	normal	fighting	0.682	t	Demo Camera	0.237	0.682	medium	1
5433cf39-2c44-4b4c-8544-0d52b0d82943	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:32.688478	normal	fighting	0.682	t	Demo Camera	0.237	0.682	medium	1
4d7a0ec3-e265-4266-a664-a40bf969ef69	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:33.675414	normal	fighting	0.86	t	Demo Camera	0.238	0.86	medium	1
0f0b7f4f-4d7d-4e3e-a181-62b7389a6828	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:33.675454	normal	fighting	0.86	t	Demo Camera	0.238	0.86	medium	1
63ca6f23-111a-498a-924c-7a3bfcf10969	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:34.608309	normal	fighting	0.585	t	Demo Camera	0.569	0.585	medium	1
ec11cf00-5d2e-4a09-9a86-277e7aad3246	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:34.608349	normal	fighting	0.585	t	Demo Camera	0.569	0.585	medium	1
cd0d8994-8a1b-4786-baae-0047c0d320d9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:35.601683	normal	forced_entry	0.677	t	Demo Camera	0.652	0.677	high	1
3f8c7a13-cb6d-46ed-83f8-d6c90d39a65f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:35.601726	normal	forced_entry	0.677	t	Demo Camera	0.652	0.677	high	1
e988492e-5692-4a1e-92a0-3e53f3de5c87	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:36.704673	normal	normal	0.802	f	Demo Camera	0.495	0.802	low	1
2104147c-d3cf-416c-a7f9-9a7428c75eca	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:36.704713	normal	normal	0.802	f	Demo Camera	0.495	0.802	low	1
19f1c330-34fc-4294-a2d3-366c72e41262	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:46.382885	abuse	abuse	0.478	t	Demo Camera	0.874	0.416	high	1
d5d3cc34-e89d-48bf-9b9e-50cb57e10bb8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:11.396455	normal	fighting	0.83	t	Demo Camera	0.623	0.83	medium	1
35e0471d-5538-423d-a628-5574b98c3acc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:11.396496	normal	fighting	0.83	t	Demo Camera	0.623	0.83	medium	1
a8627cdf-70bd-4521-b4f9-4f182faa345e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:12.344306	normal	forced_entry	0.615	t	Demo Camera	0.27	0.615	high	1
4de9bbca-1017-4caf-9faa-fe2fa1ac254a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:12.344348	normal	forced_entry	0.615	t	Demo Camera	0.27	0.615	high	1
3ff5c4c8-289c-4a89-bf85-62c5315415ee	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:13.334448	normal	fighting	0.74	t	Demo Camera	0.617	0.74	medium	1
e7fb65c0-262b-4187-bc0b-cd789b413dc2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:13.334488	normal	fighting	0.74	t	Demo Camera	0.617	0.74	medium	1
04579558-2753-4d8a-854d-538a9eb232fc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:14.31972	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
f77e5dc6-6b44-475d-b80b-c6d2053f5eb6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:14.319758	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
e6846215-2678-43e6-9433-c9d799df3bcf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:15.240056	normal	fighting	0.786	t	Demo Camera	0.656	0.786	medium	1
086bee2b-ced1-4f75-9852-1c19174db1b0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:15.24009	normal	fighting	0.786	t	Demo Camera	0.656	0.786	medium	1
1f254a8d-71b0-4cd6-a2ca-2691f067443f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:16.317004	normal	fighting	0.577	t	Demo Camera	0.391	0.577	medium	1
70ff00aa-d818-4717-8dd5-a8dcaff9919a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:16.317045	normal	fighting	0.577	t	Demo Camera	0.391	0.577	medium	1
b88a9e6e-e74d-45e0-adbd-d650e3b06edf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:17.613413	normal	normal	0.636	f	Demo Camera	0.429	0.636	low	1
6256b96b-1157-411f-a8e5-daf284cab277	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:17.613448	normal	normal	0.636	f	Demo Camera	0.429	0.636	low	1
4c318237-0cdc-402b-81eb-96d1d1bafe25	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:24.159183	fighting	fighting	0.826	t	Demo Camera	0.481	0.718	medium	1
8a2c23a8-a246-40e0-a877-d96c3d121ff8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:24.159258	fighting	fighting	0.826	t	Demo Camera	0.481	0.718	medium	1
609f36c7-a9f8-46b6-b4cd-00e8c2d1ad61	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:25.147135	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
cbbd8aee-d1b3-41f5-89c4-f57202292637	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:25.147175	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
4de059cf-0827-4185-a7d6-81ab8c1d8f7a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:26.117771	normal	intruder_detected	0.519	t	Demo Camera	0.519	0.374	medium	1
d3777c63-99cd-4122-b88c-fce9a958c6e8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:26.117814	normal	intruder_detected	0.519	t	Demo Camera	0.519	0.374	medium	1
8d3c16bf-6a50-4f17-af13-84f9f0bc4da8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:27.085057	normal	robbery	0.533	t	Demo Camera	0.533	0.476	high	1
a451585c-fe34-4dc8-a03c-64d3dcb5c6f9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:27.085093	normal	robbery	0.533	t	Demo Camera	0.533	0.476	high	1
8895fb63-375b-4ee9-916a-61c568bf80da	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:28.072375	normal	forced_entry	0.369	t	Demo Camera	0.369	0.314	high	1
b43b203b-f1c8-48d8-b2ae-aa18403f641e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:28.072456	normal	forced_entry	0.369	t	Demo Camera	0.369	0.314	high	1
fb9eb650-da7b-4d5c-8cc1-69d2af93ddb7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:29.025671	normal	fighting	0.728	t	Demo Camera	0.375	0.728	medium	1
5d996868-c2ed-485a-9f49-82c1ce0eab1f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:29.025707	normal	fighting	0.728	t	Demo Camera	0.375	0.728	medium	1
93b8db93-c3de-40a5-aff4-7bc5450b04eb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:30.039448	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
45c37c11-4334-4126-b131-6c5576641dac	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:30.039482	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
35c3560b-8fad-4819-b91a-d6a8d2c715f8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:30.978186	normal	robbery	0.61	t	Demo Camera	0.61	0.445	high	1
a4c9516e-22e5-4eba-9aca-156dff5427ec	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:30.978221	normal	robbery	0.61	t	Demo Camera	0.61	0.445	high	1
5be135a7-bb2e-4186-81cb-16c1d4a6f883	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:31.91902	normal	forced_entry	0.615	t	Demo Camera	0.424	0.615	high	1
3a2f814b-6e06-40c7-b4f6-6e38aea0fa72	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:31.919061	normal	forced_entry	0.615	t	Demo Camera	0.424	0.615	high	1
02e604af-8c72-46e1-8ce2-e425cf61076c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:32.94939	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
edabd0b7-b2e1-493a-93e5-9fc62b24c660	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:32.94943	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
8985da2b-1310-4281-8ba4-6b641cb8c328	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:33.922044	normal	robbery	0.504	t	Demo Camera	0.504	0.329	high	1
1b8b5030-3492-4009-877e-340b6f1f44d9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:33.922077	normal	robbery	0.504	t	Demo Camera	0.504	0.329	high	1
6e532a56-76b4-420b-a024-2b92e69839fe	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:34.83842	normal	fighting	0.69	t	Demo Camera	0.274	0.69	medium	1
c9481f5b-269a-4666-ae82-320d7d926183	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:34.838462	normal	fighting	0.69	t	Demo Camera	0.274	0.69	medium	1
b7254d82-43a4-406a-ac4e-cd8fe935833a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:35.848836	normal	fighting	0.765	t	Demo Camera	0.765	0.703	medium	1
2310b6df-c4be-424b-90e4-e2b2045e6bc7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:35.848874	normal	fighting	0.765	t	Demo Camera	0.765	0.703	medium	1
3f409921-c108-44c6-a120-28925b40055e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:37.020268	normal	normal	0.821	f	Demo Camera	0.417	0.821	low	1
e00b273d-2fbb-4fa3-aaef-732d22f0e5c6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:37.02031	normal	normal	0.821	f	Demo Camera	0.417	0.821	low	1
b4e2a4f1-4182-4d2d-a27c-209fe62bb03e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:46.718103	normal	abuse	0.729	t	Demo Camera	0.372	0.729	high	1
4a953aca-5971-4eca-bdb1-24282d97a170	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:11.63595	normal	fighting	0.792	t	Demo Camera	0.35	0.792	medium	1
e43c6215-0ae5-4f30-94b0-181343ac670a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:11.635994	normal	fighting	0.792	t	Demo Camera	0.35	0.792	medium	1
6e1b445d-649b-4c85-b444-0728e6cb2ac6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:12.602379	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
d97c451e-1e43-4f0d-9ccf-3f34b407c743	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:12.602414	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
ef660945-d518-498e-bbdf-14291c1b80a0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:13.584667	normal	fighting	0.86	t	Demo Camera	0.239	0.86	medium	1
b91351b6-1fa6-4a44-bf72-180a8e8db48f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:13.584709	normal	fighting	0.86	t	Demo Camera	0.239	0.86	medium	1
592f2780-f65f-483a-9ad3-2d51594493f5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:14.542664	normal	weapon_detected	0.522	t	Demo Camera	0.522	0.503	high	1
c59d3657-584b-44eb-bb5b-49350c36b2f7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:14.542741	normal	weapon_detected	0.522	t	Demo Camera	0.522	0.503	high	1
1379a0b8-171b-4948-88f0-c43c93150d02	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:15.502824	normal	forced_entry	0.677	t	Demo Camera	0.397	0.677	high	1
1f0f0e2c-61b9-41dc-a532-81ac4b2003ee	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:15.502865	normal	forced_entry	0.677	t	Demo Camera	0.397	0.677	high	1
52008c40-a42c-4ed8-a870-6d793d356d9b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:16.653858	normal	fighting	0.6	t	Demo Camera	0.6	0.599	medium	1
077d3dd3-1893-4ae2-935c-97516bb04b87	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:16.653897	normal	fighting	0.6	t	Demo Camera	0.6	0.599	medium	1
6f569b0c-be88-4ffb-b5c6-04450cf8f511	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:23:18.021804	normal	normal	0.44	f	Demo Camera	0.328	0.44	low	1
f642d819-85d7-4820-a549-22bf9e3e5f3e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:23:18.021851	normal	normal	0.44	f	Demo Camera	0.328	0.44	low	1
9d011f8f-94cc-4cca-afb9-82c6ba8cb61b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:24.389211	normal	intruder_detected	0.486	t	Demo Camera	0.475	0.486	medium	1
ff0b3322-1380-4c72-92f5-33ea1a996243	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:24.389251	normal	intruder_detected	0.486	t	Demo Camera	0.475	0.486	medium	1
d3d1f87c-dfce-4846-bdcf-639bdb0e16d1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:25.382461	normal	fighting	0.68	t	Demo Camera	0.446	0.68	medium	1
9a6292c9-dc85-403a-9af9-6ca3affce3b6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:25.382494	normal	fighting	0.68	t	Demo Camera	0.446	0.68	medium	1
66e60969-9769-41e8-8994-6e95cfde5cc7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:26.350365	normal	intruder_detected	0.641	t	Demo Camera	0.295	0.641	medium	1
b7e266b6-56cc-4608-bcf0-d974e43009ef	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:26.350404	normal	intruder_detected	0.641	t	Demo Camera	0.295	0.641	medium	1
3f68c085-8d4f-489b-b755-fc483b4ea38a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:27.340272	normal	assault	0.487	t	Demo Camera	0.487	0.339	high	1
5bce6b1f-ae83-420f-ac33-c40afcb1f0ac	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:27.34034	normal	assault	0.487	t	Demo Camera	0.487	0.339	high	1
aa7450d0-ad01-4300-bf50-d68259db0927	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:28.315601	normal	fighting	0.689	t	Demo Camera	0.572	0.689	medium	1
98a35b20-976f-439e-b06a-474078b9acf3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:28.31564	normal	fighting	0.689	t	Demo Camera	0.572	0.689	medium	1
a0a0719d-b4f0-4e2c-ac5b-88e6213de41c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:29.273311	normal	abuse	0.73	t	Demo Camera	0.73	0.376	high	1
f0692b65-a6bd-4d37-a0e1-9ea419f2c126	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:29.273351	normal	abuse	0.73	t	Demo Camera	0.73	0.376	high	1
35a3b48e-e449-4294-83db-2264dd06805b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:30.27498	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
0081bdb6-1ba0-4516-a64a-36a65fd0c9b4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:30.275015	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
50b3b302-e14b-4a68-b8f3-f444c4698c72	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:31.216842	normal	robbery	0.623	t	Demo Camera	0.623	0.348	high	1
c0291f8f-f52a-4c26-a6f5-a579af2d3731	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:31.216879	normal	robbery	0.623	t	Demo Camera	0.623	0.348	high	1
5315fd55-480e-419f-b082-1f62dd203030	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:32.170822	normal	forced_entry	0.615	t	Demo Camera	0.27	0.615	high	1
792a25bb-98b2-4318-8103-4fde1964f945	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:32.170863	normal	forced_entry	0.615	t	Demo Camera	0.27	0.615	high	1
24ffdc7a-4dd1-4b2f-a67d-2f8d056967a8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:33.181341	normal	fighting	0.74	t	Demo Camera	0.617	0.74	medium	1
b3dacf38-d175-4749-8edc-f2710f9c5f28	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:33.181381	normal	fighting	0.74	t	Demo Camera	0.617	0.74	medium	1
0d1b1981-0cd7-4a35-91d2-6c87ab084956	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:34.150956	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
7f4e17db-4771-422a-a82a-64d253ecc2b0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:34.150995	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
27a4117e-45b1-4c34-8662-69b780281f3f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:35.07149	normal	fighting	0.786	t	Demo Camera	0.656	0.786	medium	1
11163e90-4299-483a-bd58-ae0119dec10f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:35.071525	normal	fighting	0.786	t	Demo Camera	0.656	0.786	medium	1
93376c34-ae6d-409f-99ea-17a282c0e136	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:36.121211	normal	fighting	0.577	t	Demo Camera	0.391	0.577	medium	1
0eee6297-5b8e-45a7-917f-ab0f82b59395	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:36.121253	normal	fighting	0.577	t	Demo Camera	0.391	0.577	medium	1
e19f65c1-f5ff-4709-9a9a-21dc820bb84a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:37.352753	normal	normal	0.749	f	Demo Camera	0.429	0.251	low	1
685cf761-e610-4452-ab62-dd5217574b80	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:37.352787	normal	normal	0.749	f	Demo Camera	0.429	0.251	low	1
e7321946-abb9-4708-88b5-d5b27040bd0c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:46.990535	normal	abuse	0.651	t	Demo Camera	0.651	0.482	high	1
6bb679dc-3110-426b-a7d4-b0f68a0c0a89	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:37.720811	normal	normal	0.44	f	Demo Camera	0.328	0.44	low	1
1b03f7ac-08e7-422f-acc0-1e9a60612c1f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:47.29163	normal	fighting	0.406	t	Demo Camera	0.404	0.406	medium	1
bd3c82d7-dcb7-4a3b-91b9-265f944b8a12	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:47.291697	normal	fighting	0.406	t	Demo Camera	0.404	0.406	medium	1
52e8d7b7-99dd-4685-8097-4792973857a9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:57.303995	normal	normal	0.763	f	Demo Camera	0.357	0.763	low	1
9799fcb9-c6d8-425d-880f-1773c659dcb0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:57.304034	normal	normal	0.763	f	Demo Camera	0.357	0.763	low	1
9194933e-5d51-4193-95e8-a3fc93108f4b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:59.731146	normal	vehicle_intrusion	0.723	t	Demo Camera	0.723	0.334	medium	1
b4a27dfc-e573-470d-8785-a5bb4f8c92a5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:59.731184	normal	vehicle_intrusion	0.723	t	Demo Camera	0.723	0.334	medium	1
228836a2-497c-4b93-aa59-15fe8ee20886	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:27:02.168724	normal	normal	0.748	f	Demo Camera	0.679	0.748	low	1
65e6df38-1f94-46d0-a11f-070933433f1b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:27:02.168758	normal	normal	0.748	f	Demo Camera	0.679	0.748	low	1
c160abb2-44bc-4310-bc23-3ade8e18a535	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:20.002154	distress_sounds	weapon_detected	0.714	t	Demo Camera	0.84	0.767	high	1
f5944656-c58c-40bd-9dcc-f893d363e4cf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:20.002195	distress_sounds	weapon_detected	0.714	t	Demo Camera	0.84	0.767	high	1
76d9b87b-cbb4-4ec8-9cb0-ac1f208959ec	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:48.428357	normal	violence	0.99	t	Demo Camera	0.219	0.99	high	1
971460a3-aac6-4ee6-9aa2-ac2e57fd6702	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:48.428567	normal	violence	0.99	t	Demo Camera	0.219	0.99	high	1
4b1f81ba-f0b6-4d65-b9ae-b28fa40decb1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:49.996021	normal	violence	0.886	t	Demo Camera	0.229	0.886	high	1
fafb75d7-afa3-484a-9f69-ae956a5899f5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:49.996229	normal	violence	0.886	t	Demo Camera	0.229	0.886	high	1
81afa7d7-6175-45de-8aea-025bbac728e7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:51.565219	normal	violence	0.947	t	Demo Camera	0.457	0.947	high	1
4fe65fc3-ee2a-408d-9402-0eccffdcc250	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:51.56543	normal	violence	0.947	t	Demo Camera	0.457	0.947	high	1
040ea0d2-fa92-4aff-bc30-06b0345f2b9e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:53.122659	normal	violence	0.99	t	Demo Camera	0.394	0.99	high	1
a567e656-4fba-47c8-b262-c0301df27c02	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:53.122814	normal	violence	0.99	t	Demo Camera	0.394	0.99	high	1
5f1f711e-09ba-4dcc-9c22-770f0dfba689	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:54.701416	normal	violence	0.99	t	Demo Camera	0.193	0.99	high	1
60d41147-0f0f-471f-8349-bc2b8326d95e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:54.701565	normal	violence	0.99	t	Demo Camera	0.193	0.99	high	1
bd533668-cdb1-430d-ab00-22d38ff794e9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:56.306595	normal	violence	0.99	t	Demo Camera	0.401	0.99	high	1
02674a98-516d-479d-9192-ad6fe186218f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:56.306803	normal	violence	0.99	t	Demo Camera	0.401	0.99	high	1
b7d5c4ad-7c90-431e-bd1e-0ccffe1250ad	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:57.839968	normal	normal	0.8	f	Demo Camera	0.2	0.503	low	1
4ff70b14-0e0d-4680-9e7a-b4bec11249a3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:57.840158	normal	normal	0.8	f	Demo Camera	0.2	0.503	low	1
f3575529-24b2-4965-9d0b-0a1bf350361f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:59.413489	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
4ccc6ca1-b952-46a9-8791-2da2b2658d4a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:59.413638	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
eddd34f7-bf96-4189-be49-53800d90bd1e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:47:01.104409	normal	violence	0.99	t	Demo Camera	0.216	0.99	high	1
905c3c3c-f48f-44c4-a586-c5922dad505d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:47:01.104614	normal	violence	0.99	t	Demo Camera	0.216	0.99	high	1
041adff4-c1c4-4d51-86ed-17d6e7f120f4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:47:02.973639	impact	normal	0.681	t	Demo Camera	0.501	0.681	high	1
c324a3e2-8ca5-4f7d-976f-cb00cf747580	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:47:02.973778	impact	normal	0.681	t	Demo Camera	0.501	0.681	high	1
46c01fb0-441b-4ab4-9a8a-9b11e99b822f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:07.422555	normal	normal	0.9	f	Demo Camera	0.441	0.9	low	1
6dd698e3-e0c0-4074-ae1a-b4c64317b42e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:07.422702	normal	normal	0.9	f	Demo Camera	0.441	0.9	low	1
1840533d-1f0a-4d11-915f-8575c5a40816	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:10.614936	normal	normal	0.841	f	Demo Camera	0.79	0.841	low	1
ff471ec9-9bad-40ff-8bd1-758eeb0eef50	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:10.615134	normal	normal	0.841	f	Demo Camera	0.79	0.841	low	1
0ab19d67-9004-4a86-80f3-146ee3a3663b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:24.6714	normal	weapon_detected	0.904	t	Demo Camera	0.641	0.904	high	1
1e3b1598-9fbe-49e7-97ee-a606c558b5f0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:24.671551	normal	weapon_detected	0.904	t	Demo Camera	0.641	0.904	high	1
1430a9f4-c8af-4b30-9912-afbb075bfe1e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:48.16698	normal	normal	0.813	f	Demo Camera	0.187	0.804	low	1
84487961-e662-4853-897d-84fb1fddcd8a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:48.16711	normal	normal	0.813	f	Demo Camera	0.187	0.804	low	1
10016498-35b4-45d1-a800-e09c9a904a12	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:54.847372	normal	normal	0.541	f	Demo Camera	0.431	0.459	low	1
00c03316-e277-4098-85be-7fa7c6e47495	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:54.847566	normal	normal	0.541	f	Demo Camera	0.431	0.459	low	1
b2ec1d93-fbb9-4124-a146-ab07b3fa967c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:03.56773	normal	normal	0.838	f	Demo Camera	0.23	0.838	low	1
23adb558-887b-4042-9af6-d78827aca434	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:03.567842	normal	normal	0.838	f	Demo Camera	0.23	0.838	low	1
872728eb-6f12-461e-add4-b175d14c9b17	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:46.382966	abuse	abuse	0.478	t	Demo Camera	0.874	0.416	high	1
fbf9eb76-427d-465b-9a8c-72ebb601d283	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:47.583482	normal	fighting	0.594	t	Demo Camera	0.594	0.441	medium	1
cbba941b-3291-4850-86e5-db375e3cb566	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:47.583521	normal	fighting	0.594	t	Demo Camera	0.594	0.441	medium	1
f1fcee3a-203b-4f47-999f-afb59db361f6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:57.974429	normal	normal	0.775	f	Demo Camera	0.571	0.225	low	1
3b2cc678-14fe-47a6-9043-4c13dd26f5fa	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:57.974469	normal	normal	0.775	f	Demo Camera	0.571	0.225	low	1
055520ff-6579-4a00-b29a-c488e2796670	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:27:00.392727	normal	vehicle_intrusion	0.734	t	Demo Camera	0.734	0.334	medium	1
e7eb6bff-414e-41d4-99a2-0ef944d3c1cb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:27:00.392771	normal	vehicle_intrusion	0.734	t	Demo Camera	0.734	0.334	medium	1
a2fd877e-3d12-494b-a9e0-7b83f2ecd3cd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:27:02.807291	normal	normal	0.67	f	Demo Camera	0.67	0.278	low	1
9251d54e-3b9f-4852-a0aa-6707d39858f6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:27:02.807331	normal	normal	0.67	f	Demo Camera	0.67	0.278	low	1
d9653c0d-a66a-4903-9e31-47940767896a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:20.74755	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
4600c441-7147-4d36-a869-05cfab337907	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:20.74759	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
c910a88c-a496-4fc7-8100-67bbcb9c1466	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 10:02:23.165652	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
167083dd-e581-4e16-8f62-1fe7a984f22d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 10:02:23.165687	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
618d2252-4327-4924-8358-11759a2b43bd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:49.196771	normal	violence	0.986	t	Demo Camera	0.4	0.986	high	1
2982ab0a-eeea-4476-b5dd-c82792a4595d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:50.791387	normal	violence	0.99	t	Demo Camera	0.192	0.99	high	1
02b9c781-1eac-4e49-a7c6-23c6b3ed6cdb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:50.791562	normal	violence	0.99	t	Demo Camera	0.192	0.99	high	1
bcb1b780-e1ff-4b28-a955-d575d45a5db8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:52.346002	normal	violence	0.99	t	Demo Camera	0.692	0.99	high	1
b71bb364-3f76-4749-b260-986b90a43ac5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:52.346218	normal	violence	0.99	t	Demo Camera	0.692	0.99	high	1
39def14c-bb61-42de-94f6-4aea76e33a44	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:53.892233	normal	weapon_detected	0.942	t	Demo Camera	0.462	0.942	high	1
469f17c5-f53a-426e-997c-7c6f2a70bd72	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:53.892384	normal	weapon_detected	0.942	t	Demo Camera	0.462	0.942	high	1
0e19a677-5504-4f4f-be6e-32d266e69a62	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:55.513315	normal	violence	0.99	t	Demo Camera	0.346	0.99	high	1
b38070e1-76b1-4491-a2b5-ce57faf2eaa1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:55.513478	normal	violence	0.99	t	Demo Camera	0.346	0.99	high	1
fe26e8df-e5b7-4282-8320-aa0391461d34	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:57.106068	normal	violence	0.99	t	Demo Camera	0.267	0.99	high	1
e97f9dc2-df2a-4bd9-b835-ea8237805ed5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:57.106207	normal	violence	0.99	t	Demo Camera	0.267	0.99	high	1
ec23720b-83a5-4ee2-b510-f53ea49e4868	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:58.605046	normal	violence	0.99	t	Demo Camera	0.762	0.99	high	1
c287db41-c757-45ae-aee2-6b382ae79709	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:58.605174	normal	violence	0.99	t	Demo Camera	0.762	0.99	high	1
4d920b45-0577-4671-a8aa-8f12a26709af	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:47:00.222954	normal	violence	0.99	t	Demo Camera	0.742	0.99	high	1
5ae7ece4-a82a-4d31-85f7-b342701c331b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:47:00.223162	normal	violence	0.99	t	Demo Camera	0.742	0.99	high	1
3065bd88-1469-4fdb-ba70-31fc4300a261	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:47:01.995235	normal	normal	0.804	f	Demo Camera	0.196	0.396	low	1
c5c4dc21-ecd7-431b-98cc-1587b1988bf3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:47:01.995401	normal	normal	0.804	f	Demo Camera	0.196	0.396	low	1
94e1e028-833a-4001-ac40-4cfcc33e40de	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:05.820004	normal	normal	0.845	f	Demo Camera	0.46	0.845	low	1
53fb5978-f05e-4240-81ae-b4f4df728262	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:05.820222	normal	normal	0.845	f	Demo Camera	0.46	0.845	low	1
b04b444e-65d1-42df-8d98-85f238ac2e61	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:09.023411	normal	normal	0.838	f	Demo Camera	0.84	0.838	low	1
0d2e655e-8443-44f3-b472-889289d0d5ab	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:09.023602	normal	normal	0.838	f	Demo Camera	0.84	0.838	low	1
bcae0706-8c48-4249-be07-812081a99817	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:12.186677	normal	normal	0.832	f	Demo Camera	0.75	0.832	low	1
13f40005-0dbc-4982-98d1-1698677f5e7a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:12.186881	normal	normal	0.832	f	Demo Camera	0.75	0.832	low	1
14d78ba5-b2c3-4ace-b055-e3b19e0d6dd4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:25.22214	normal	weapon_detected	0.981	t	Demo Camera	0.406	0.981	high	1
32050a78-7c23-4919-a8cd-fe4d9a2d5c0b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:25.222288	normal	weapon_detected	0.981	t	Demo Camera	0.406	0.981	high	1
13db3ca3-071f-4873-8b55-f6859558383b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:48.940757	normal	normal	0.841	f	Demo Camera	0.23	0.841	low	1
3d84ac56-c683-4c07-8676-6a35d07f316c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:48.940963	normal	normal	0.841	f	Demo Camera	0.23	0.841	low	1
2aaa6933-7191-42dc-904f-cc741a2fa631	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:55.642112	normal	weapon_detected	0.846	t	Demo Camera	0.513	0.737	high	1
59c140c8-9a9e-4f13-b32a-cbfb40babc21	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:55.642263	normal	weapon_detected	0.846	t	Demo Camera	0.513	0.737	high	1
0dc3420a-6b50-40a2-aeaf-4fe83622dc00	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:04.529195	normal	normal	0.809	f	Demo Camera	0.227	0.809	low	1
3ea4f3cd-5960-4bbc-9a18-7f549f245eee	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:46.718172	normal	abuse	0.729	t	Demo Camera	0.372	0.729	high	1
598ffa3a-3322-450a-b5f1-07e92ff182a8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:47.925655	fighting	fighting	0.507	t	Demo Camera	0.543	0.441	medium	1
9b26ee35-5917-44e2-9704-5036d3efffcc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:47.925725	fighting	fighting	0.507	t	Demo Camera	0.543	0.441	medium	1
c4ce3976-4bb5-4357-9382-475a04ed8253	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:58.52312	normal	normal	0.746	f	Demo Camera	0.386	0.746	low	1
fb8a57ef-2e13-4fe5-ae0b-ec9102eaf219	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:58.523161	normal	normal	0.746	f	Demo Camera	0.386	0.746	low	1
410d4e07-b17f-4f6f-b957-534bd08bb74f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:27:00.944821	normal	normal	0.667	f	Demo Camera	0.667	0.289	low	1
e4b73b98-8327-4aba-b7ca-9c29d1b35abc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:27:00.94486	normal	normal	0.667	f	Demo Camera	0.667	0.289	low	1
eef9ee2a-9c27-455b-924a-3d7bd59b574f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:27:03.461625	normal	normal	0.637	f	Demo Camera	0.637	0.271	low	1
6b7b117a-f5a3-45a9-ba42-1631209fcdfb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:27:03.461663	normal	normal	0.637	f	Demo Camera	0.637	0.271	low	1
75b25570-6ba6-4007-91b6-e3678675de1b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:29:52.367892	normal	normal	0.857	f	Demo Camera	0.543	0.857	low	1
4cee9eb5-4930-415b-8b3a-645a16b35b23	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:29:52.367985	normal	normal	0.857	f	Demo Camera	0.543	0.857	low	1
331000c5-a902-42d8-af60-2e3dde37ca96	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:29:53.446649	normal	normal	0.817	f	Demo Camera	0.183	0.816	low	1
287b476e-5451-45b7-8110-105138f281db	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:29:53.446694	normal	normal	0.817	f	Demo Camera	0.183	0.816	low	1
4ed0ff58-e6c1-4430-8581-e12abc34a967	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:29:55.429	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
b714c150-80ce-4406-a903-894af8ff7326	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:29:55.429033	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
0500d7b2-99bc-4417-8f08-74557d891e97	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:10.618917	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
1a8b002d-ae4e-4a88-b2e5-1fcaf823970e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:10.618953	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
d68ae4e1-99a1-48ca-8170-f278ed37d070	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:12.287096	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
502518e1-2312-46b7-8b84-30e054d72baa	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:12.287133	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
62f72d6e-a294-47d2-81c8-a01663f57598	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:15.585469	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
db53592f-0926-4703-8eed-e02c06a04c4d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:15.585507	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
07b3b668-549f-408d-9efa-f2280f299328	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:51.956239	normal	violence	0.936	t	Demo Camera	0.329	0.936	high	1
03727bcf-35d4-4d85-b70a-0c3b034b6e23	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:53.507211	normal	violence	0.99	t	Demo Camera	0.353	0.99	high	1
ffb4ecf1-9101-45f0-ba1d-50994d0400d1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:53.507371	normal	violence	0.99	t	Demo Camera	0.353	0.99	high	1
4f5f9736-32ee-4763-b363-0adf46f05aa9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:56.703243	normal	violence	0.99	t	Demo Camera	0.197	0.99	high	1
3ad7cff6-c206-4f97-8136-ba909e5efb44	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:56.703328	normal	violence	0.99	t	Demo Camera	0.197	0.99	high	1
db3a1073-12f7-476c-a2c8-f02599a98b94	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:58.221561	normal	violence	0.99	t	Demo Camera	0.341	0.99	high	1
4c5801ac-7368-4242-80ce-5db9926c0698	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:58.221766	normal	violence	0.99	t	Demo Camera	0.341	0.99	high	1
a4749d02-6723-4ace-bd80-a747314fb09f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:59.822031	normal	violence	0.92	t	Demo Camera	0.267	0.903	high	1
75248a9e-e7cf-45f4-9620-b7cdc7f666f7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:59.822244	normal	violence	0.92	t	Demo Camera	0.267	0.903	high	1
25b96801-c9ec-4e28-8122-c5384dc5aa0a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:47:01.526685	normal	violence	0.99	t	Demo Camera	0.749	0.99	high	1
fe69a681-c7af-44e0-a2d2-887da77f961c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:47:01.526888	normal	violence	0.99	t	Demo Camera	0.749	0.99	high	1
5163ce1e-316c-48f8-9444-57010ca4b40d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:04.94445	normal	normal	0.893	f	Demo Camera	0.261	0.893	low	1
2551ec6f-94ca-4df4-85a3-a093b95efe21	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:04.945352	normal	normal	0.893	f	Demo Camera	0.261	0.893	low	1
190efebc-64cc-4d36-bc5f-0f9bd8266769	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:08.167707	normal	normal	0.846	f	Demo Camera	0.771	0.846	low	1
199e1035-9d2c-4467-8aa2-ec3fa045d6c0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:08.167882	normal	normal	0.846	f	Demo Camera	0.771	0.846	low	1
0b7b0bed-357c-4073-8a9e-ff0c560ee025	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:11.361684	normal	normal	0.837	f	Demo Camera	0.802	0.837	low	1
aaf79454-c2d1-495b-8390-1d3b23855621	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:11.361861	normal	normal	0.837	f	Demo Camera	0.802	0.837	low	1
77a16065-d1ec-47d7-b92f-7ddec513260b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:04.529294	normal	normal	0.809	f	Demo Camera	0.227	0.809	low	1
c759b61c-6a0a-4221-8f2c-295813aea866	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:07.858709	normal	weapon_detected	0.574	t	Demo Camera	0.286	0.574	high	1
4a93d151-ba18-4893-a3d5-a1cc912042cc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:07.858867	normal	weapon_detected	0.574	t	Demo Camera	0.286	0.574	high	1
98170257-e531-472d-bd43-ea01b1b4ea03	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:10.317006	normal	weapon_detected	0.846	t	Demo Camera	0.513	0.737	high	1
e36d6a4b-332b-4b99-9a88-701d6bc7772b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:10.317091	normal	weapon_detected	0.846	t	Demo Camera	0.513	0.737	high	1
4854784f-b239-4b38-b013-bcb96832d43b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:27.774482	normal	weapon_detected	0.99	t	Demo Camera	0.238	0.99	high	1
f6aa0ee1-20b2-4bba-bcf9-ce0b5f227cfd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:46.99057	normal	abuse	0.651	t	Demo Camera	0.651	0.482	high	1
a2855738-74bc-41b2-bfc3-f4e99774b5f9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:48.260053	fighting	fighting	0.448	t	Demo Camera	0.745	0.39	medium	1
e9f2ad16-39fd-43e9-b124-39d135f50e2e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:48.260093	fighting	fighting	0.448	t	Demo Camera	0.745	0.39	medium	1
f4af32bb-833f-4467-8016-fa80c337c1d9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:26:59.176507	normal	vehicle_intrusion	0.724	t	Demo Camera	0.724	0.302	medium	1
a054cda9-bbf5-4ba4-90c2-b8297e70f9ef	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:26:59.17659	normal	vehicle_intrusion	0.724	t	Demo Camera	0.724	0.302	medium	1
1aa918fe-810f-4531-b77a-83ec4ac23cea	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:27:01.613417	normal	normal	0.748	f	Demo Camera	0.681	0.748	low	1
ac3e11d0-41d7-4543-a59a-0a80b15356d5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:27:01.613456	normal	normal	0.748	f	Demo Camera	0.681	0.748	low	1
8128d266-ad61-4316-8886-66e4d9161e89	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:07.195269	normal	normal	0.781	f	Demo Camera	0.219	0.763	low	1
f3288784-9841-4fc1-be2b-d335d9cd1f0c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:07.195308	normal	normal	0.781	f	Demo Camera	0.219	0.763	low	1
3434d712-c744-44c8-81c1-6f84ee75a92e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:07.880356	gunshot	normal	0.775	t	Demo Camera	0.429	0.225	high	1
32f15a27-79d0-4ede-b5a1-1d80c57fe950	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:07.880433	gunshot	normal	0.775	t	Demo Camera	0.429	0.225	high	1
6a2911b1-91f5-43ff-aeb0-f3d08d9dfbca	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:08.43849	normal	normal	0.814	f	Demo Camera	0.186	0.746	low	1
e74a7420-65fc-4a26-be54-0fed165b9e99	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:08.438533	normal	normal	0.814	f	Demo Camera	0.186	0.746	low	1
92dead03-9783-4e54-80ec-b076d4c0c0bf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:09.094544	vehicle_intrusion	vehicle_intrusion	0.347	t	Demo Camera	0.276	0.302	medium	1
0b9963a3-e432-465a-ba8b-4ad37d057750	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:09.094619	vehicle_intrusion	vehicle_intrusion	0.347	t	Demo Camera	0.276	0.302	medium	1
b5982b13-f487-4eb3-b0bf-0bbc58a31392	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:09.656977	vehicle_intrusion	vehicle_intrusion	0.384	t	Demo Camera	0.277	0.334	medium	1
c71b2a8e-5b29-45f1-a899-f0e636f964f1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:09.657016	vehicle_intrusion	vehicle_intrusion	0.384	t	Demo Camera	0.277	0.334	medium	1
0bfbc83b-d526-4f16-a53e-1dc004700978	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:10.339411	vehicle_intrusion	vehicle_intrusion	0.384	t	Demo Camera	0.266	0.334	medium	1
77903a93-31e9-41b3-ac3d-eff735d85d71	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:10.33945	vehicle_intrusion	vehicle_intrusion	0.384	t	Demo Camera	0.266	0.334	medium	1
52a851e8-af5d-4883-a0fb-70ff6c1bfa75	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:10.905535	scream	normal	0.333	t	Demo Camera	0.333	0.289	high	1
8ef55d02-9762-4dda-8e5c-edf0d2244375	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:10.905629	scream	normal	0.333	t	Demo Camera	0.333	0.289	high	1
76648267-a6a4-4b63-b02f-836a1989c3eb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:11.555909	scream	normal	0.748	t	Demo Camera	0.319	0.748	high	1
ee9529f0-ea6b-43b3-90b6-a82e5be72d51	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:11.555949	scream	normal	0.748	t	Demo Camera	0.319	0.748	high	1
dcd2a02c-2d14-45ca-b3ea-a8f747302818	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:12.121201	scream	normal	0.748	t	Demo Camera	0.321	0.748	high	1
75cc4b73-9793-4eef-9cef-dc11b91ac1f1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:12.121242	scream	normal	0.748	t	Demo Camera	0.321	0.748	high	1
bd24829c-e95a-4f39-a8f7-df55c34121d7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:12.771189	scream	normal	0.33	t	Demo Camera	0.33	0.278	high	1
89e068fd-64de-4ccd-99f7-33fdaaae2e26	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:12.771229	scream	normal	0.33	t	Demo Camera	0.33	0.278	high	1
91d96525-6b1e-4c38-9c4f-d2e7b4468a09	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:13.431578	fight_sounds	normal	0.363	t	Demo Camera	0.363	0.271	high	1
637223f9-8f4c-4813-80f7-9b9676ec7c67	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:13.431654	fight_sounds	normal	0.363	t	Demo Camera	0.363	0.271	high	1
9a5db182-e585-4628-9bd5-d6c6b38bbf5e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:21.998769	abuse	abuse	0.478	t	Demo Camera	0.874	0.416	high	1
02058c79-ac5f-477a-8e59-30f8e864afb8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:21.998849	abuse	abuse	0.478	t	Demo Camera	0.874	0.416	high	1
763af025-d7f5-4ed6-9cdf-c567a5b14557	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:22.330399	normal	abuse	0.729	t	Demo Camera	0.372	0.729	high	1
b8cb4657-fd17-42ea-b7b8-d9ebd80faaa3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:22.330473	normal	abuse	0.729	t	Demo Camera	0.372	0.729	high	1
a409382d-1154-473e-846d-16516e866678	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:22.589135	normal	abuse	0.651	t	Demo Camera	0.651	0.482	high	1
de29565a-246e-4d56-8939-7b6139389050	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:22.58917	normal	abuse	0.651	t	Demo Camera	0.651	0.482	high	1
11589dea-c5e2-46ea-937f-9de439469810	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:22.924098	normal	fighting	0.406	t	Demo Camera	0.404	0.406	medium	1
d2b6c7f0-dbb9-40b7-bd94-adaf10a62e9a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:22.924179	normal	fighting	0.406	t	Demo Camera	0.404	0.406	medium	1
1c3d661d-8b9a-426e-88ea-549f7ac6156e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:23.209346	fight_sounds	weapon_detected	0.637	t	Demo Camera	0.406	0.441	high	1
e653742b-5faa-46fe-bba8-688d59acc578	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:23.209415	fight_sounds	weapon_detected	0.637	t	Demo Camera	0.406	0.441	high	1
3ca170bb-5a72-44b5-a04f-1ef393eab265	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:23.560082	fighting	fighting	0.507	t	Demo Camera	0.543	0.441	medium	1
6adb3fce-030c-4033-805d-132b285fc05b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:23.560159	fighting	fighting	0.507	t	Demo Camera	0.543	0.441	medium	1
fb3bc729-c0c1-424c-be5c-773627d47904	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:23.891496	fighting	fighting	0.448	t	Demo Camera	0.745	0.39	medium	1
81a860e0-4cc7-4297-bd53-0a3359f0c213	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:23.89153	fighting	fighting	0.448	t	Demo Camera	0.745	0.39	medium	1
b45b891b-e4bd-47cd-bd49-89dfeb1bc972	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:35.672865	normal	robbery	0.4	t	Demo Camera	0.4	0.303	high	1
f2b8c266-5b7d-4f45-8ea3-89e9b2eb8f04	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:35.672905	normal	robbery	0.4	t	Demo Camera	0.4	0.303	high	1
dab79043-62d6-4843-8c70-3aafde3c1bd7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:38.216043	normal	vehicle_intrusion	0.314	t	Demo Camera	0.309	0.314	medium	1
ffd56e92-5711-4670-a029-c79a550b0504	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:38.216124	normal	vehicle_intrusion	0.314	t	Demo Camera	0.309	0.314	medium	1
0ef06084-0b2e-43af-95a4-042193dd5812	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:12.01679	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
a4d1b793-c052-4df6-8738-a16ccad17c0a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:12.016831	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
1325b18f-d76d-489d-8537-36b3e02a51ee	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:14.554799	normal	normal	0.766	f	Demo Camera	0.407	0.234	low	1
fa34b919-cb09-4121-85cd-e0348808004a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:14.554831	normal	normal	0.766	f	Demo Camera	0.407	0.234	low	1
b39b05c2-ff55-4dbf-9b67-476c9cdb4482	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:17.237432	normal	normal	0.665	f	Demo Camera	0.404	0.335	low	1
9cc77e00-4a2f-4ea5-ad21-b85e7f55067c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:17.237473	normal	normal	0.665	f	Demo Camera	0.404	0.335	low	1
158e042f-c227-43ad-a162-ef6464068d04	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:26.855041	normal	abuse	0.729	t	Demo Camera	0.372	0.729	high	1
b93fc4be-450b-4c1f-bafa-1f3f8625cff2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:26.85511	normal	abuse	0.729	t	Demo Camera	0.372	0.729	high	1
68fc9f75-6d57-4850-9a0f-7b4f8051eb37	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:28.058678	normal	fighting	0.837	t	Demo Camera	0.543	0.441	medium	1
2041bbca-cccf-4ffd-bce8-5b33350ed254	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:28.058711	normal	fighting	0.837	t	Demo Camera	0.543	0.441	medium	1
c5384139-d6fe-405c-a8ef-4b6bd0f12f58	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:44.099568	normal	fighting	0.856	t	Demo Camera	0.481	0.718	medium	1
89bc95e6-3aff-438e-8108-1bf48dae2b57	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:44.099607	normal	fighting	0.856	t	Demo Camera	0.481	0.718	medium	1
4e64170b-7c4c-46ee-8a51-9ac71810faac	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:45.101193	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
c981e33e-04c6-4c92-9f20-3787275ac878	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:45.101231	normal	fighting	0.793	t	Demo Camera	0.365	0.793	medium	1
f8900521-aa2f-4db4-a34b-7d9471bfa4af	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:46.055997	normal	normal	0.626	f	Demo Camera	0.519	0.374	low	1
cece7c15-e064-441e-982c-1847804dfb3d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:46.056038	normal	normal	0.626	f	Demo Camera	0.519	0.374	low	1
dc8afbb8-b32d-4bf4-90a2-4b9181582ff8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:47.045158	normal	robbery	0.533	t	Demo Camera	0.533	0.476	high	1
7a42792f-a599-4672-8911-aa7fa775a871	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:47.045198	normal	robbery	0.533	t	Demo Camera	0.533	0.476	high	1
cea308b1-446d-4d84-9f66-92904c5b1bec	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:48.01912	normal	normal	0.686	f	Demo Camera	0.369	0.314	low	1
68caf3c0-284f-4092-82df-9cf4a9e7f380	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:48.01916	normal	normal	0.686	f	Demo Camera	0.369	0.314	low	1
0ecc561f-c681-4df6-85f1-37494e71b8c0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:48.994561	normal	fighting	0.728	t	Demo Camera	0.375	0.728	medium	1
8812dc8a-b8f0-4586-89eb-1bd6745dea50	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:48.994602	normal	fighting	0.728	t	Demo Camera	0.375	0.728	medium	1
aa54fdb8-68f6-49af-9587-1c76f138825b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:49.992774	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
224db17e-4fb0-4985-93a4-e34bc8f0b484	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:49.992813	normal	fighting	0.558	t	Demo Camera	0.558	0.503	medium	1
afa7f362-5080-4f90-9eb1-a544504e83e4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:50.949405	normal	robbery	0.61	t	Demo Camera	0.61	0.445	high	1
ab961256-4bf4-4f2f-80e9-29672780a20a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:50.949443	normal	robbery	0.61	t	Demo Camera	0.61	0.445	high	1
68a18dea-ddac-46a8-b2a7-465b47523aac	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:51.893458	normal	forced_entry	0.615	t	Demo Camera	0.424	0.615	high	1
3c8844a2-7dfd-4132-888b-9c0aad8d47a9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:51.893536	normal	forced_entry	0.615	t	Demo Camera	0.424	0.615	high	1
a004d07d-b1bc-4aa6-a8ac-e4056126d960	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:52.92087	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
5f02bf23-e235-42cc-8fcc-b7346b769dab	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:52.920904	normal	fighting	0.852	t	Demo Camera	0.436	0.852	medium	1
95133a76-a45f-4882-824a-1b0d623739b0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:53.891636	normal	normal	0.671	f	Demo Camera	0.504	0.329	low	1
82039788-39e0-48fe-ad9c-7b4a3d24c929	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:53.891676	normal	normal	0.671	f	Demo Camera	0.504	0.329	low	1
0858055b-3ec1-4bd0-af60-9e54f5d5583c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:54.815559	normal	fighting	0.69	t	Demo Camera	0.274	0.69	medium	1
483d563e-fb7a-41ad-975a-d635586d24bf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:54.815599	normal	fighting	0.69	t	Demo Camera	0.274	0.69	medium	1
036eb6dc-27cc-4f87-9e58-a84b28943db5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:55.814064	normal	fighting	0.765	t	Demo Camera	0.765	0.703	medium	1
2b9c1d8f-141a-41f0-bc7a-ff4bbb7f6744	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:55.814102	normal	fighting	0.765	t	Demo Camera	0.765	0.703	medium	1
35c4702b-6527-455a-bf35-12c2f5318ffb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:56.990107	normal	normal	0.821	f	Demo Camera	0.417	0.821	low	1
302a2778-29e4-463e-aeaa-9b5bb743050b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:56.990146	normal	normal	0.821	f	Demo Camera	0.417	0.821	low	1
a4d38510-690f-4b89-8f48-e405deeba4b9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:33.712466	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
6b27f7b6-74fd-456e-aa4d-a9ee6716687d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:33.712504	normal	normal	0.816	f	Demo Camera	0.47	0.816	low	1
a76316fa-53f7-41a1-83ca-f3b79bc54b9a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:36.272081	normal	normal	0.766	f	Demo Camera	0.407	0.234	low	1
38de6447-c76a-461d-99c0-6b10511bb2b6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:36.27212	normal	normal	0.766	f	Demo Camera	0.407	0.234	low	1
598d2ff1-e64c-4e76-9b02-9df215e3594a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:38.913422	normal	vehicle_intrusion	0.404	t	Demo Camera	0.404	0.335	medium	1
356bfbb6-b830-4ced-aef8-aa9e15772375	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:38.913458	normal	vehicle_intrusion	0.404	t	Demo Camera	0.404	0.335	medium	1
6cfc773d-f9a5-4ae2-92fe-07a099a868f6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:12.703382	normal	normal	0.542	f	Demo Camera	0.542	0.211	low	1
2fa98f7a-ef9b-413b-8a34-c5cc06b73f9c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:12.703423	normal	normal	0.542	f	Demo Camera	0.542	0.211	low	1
9895a60d-24f7-41c7-b125-6dd833ca6f81	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:15.266865	normal	normal	0.766	f	Demo Camera	0.243	0.234	low	1
48b557ec-782d-48d8-a0c0-58e3b2b1bec1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:15.266909	normal	normal	0.766	f	Demo Camera	0.243	0.234	low	1
31c2c250-c27a-4b79-8aa9-38d2c05a1547	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:17.837513	normal	normal	0.682	f	Demo Camera	0.48	0.318	low	1
6354f93b-4ffd-4fef-9bf8-304f94ae6df0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:17.837553	normal	normal	0.682	f	Demo Camera	0.48	0.318	low	1
dffd2a36-28c8-46f4-aa6c-5544bfb0e2c4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:27.126057	normal	abuse	0.651	t	Demo Camera	0.651	0.482	high	1
fc8864f1-3b8a-4af7-886b-1583c89c7830	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:27.126091	normal	abuse	0.651	t	Demo Camera	0.651	0.482	high	1
9d6419a3-9937-47fb-834b-8b7394c16573	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:28.387544	normal	normal	0.776	f	Demo Camera	0.745	0.39	low	1
902cb28a-d8dd-4bdf-b175-b52acb9dba86	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:28.387578	normal	normal	0.776	f	Demo Camera	0.745	0.39	low	1
61099b60-255e-4cba-9ffb-7cd5786ab940	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:44.345821	normal	intruder_detected	0.486	t	Demo Camera	0.475	0.486	medium	1
909ca26d-3e6b-4158-87a0-7fa091e48e7f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:44.34586	normal	intruder_detected	0.486	t	Demo Camera	0.475	0.486	medium	1
60586a28-a40f-484a-8663-03c0a8f68206	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:45.332972	normal	fighting	0.68	t	Demo Camera	0.446	0.68	medium	1
ab2a8650-6752-4c79-b7b8-3cff6f412b81	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:45.33301	normal	fighting	0.68	t	Demo Camera	0.446	0.68	medium	1
f6c54617-3645-4bd8-a207-685af04ca106	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:46.300728	normal	intruder_detected	0.808	t	Demo Camera	0.192	0.641	medium	1
e48c4b32-085b-421d-8ed9-57b348b09a99	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:46.300768	normal	intruder_detected	0.808	t	Demo Camera	0.192	0.641	medium	1
0a5b2e62-1a27-462b-b2a3-cc3feb216549	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:47.285729	normal	normal	0.661	f	Demo Camera	0.487	0.339	low	1
fe12ecc8-5d8d-4144-8909-e714765c82c8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:47.285768	normal	normal	0.661	f	Demo Camera	0.487	0.339	low	1
e3998028-5908-441a-86ed-abe15660e976	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:48.274435	normal	fighting	0.689	t	Demo Camera	0.572	0.689	medium	1
ca824820-5293-484f-81d7-0e76f6cb1335	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:48.27448	normal	fighting	0.689	t	Demo Camera	0.572	0.689	medium	1
8f059d2d-0318-4785-b260-af15392cb098	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:49.233779	normal	normal	0.73	f	Demo Camera	0.73	0.376	low	1
0c1e2780-d2ac-4596-87cf-0ad6fc4522c1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:49.233839	normal	normal	0.73	f	Demo Camera	0.73	0.376	low	1
8d6d33ba-54c9-4526-a31b-efc8a5d16c9c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:50.224914	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
b0ac08a1-2d5d-447d-bef1-5aba58a38104	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:50.224948	normal	fighting	0.729	t	Demo Camera	0.615	0.729	medium	1
ede6cebd-15a5-4c5f-9a2d-8ed4091014eb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:51.188179	normal	normal	0.652	f	Demo Camera	0.623	0.348	low	1
373ea8db-46ec-424c-a54b-bb46707b6397	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:51.188224	normal	normal	0.652	f	Demo Camera	0.623	0.348	low	1
84b6a795-9abe-48f1-b09d-887cab09b1f6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:52.158281	normal	forced_entry	0.615	t	Demo Camera	0.27	0.615	high	1
5af0f40e-5d3e-49fb-a380-32ecf15b2da3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:52.158322	normal	forced_entry	0.615	t	Demo Camera	0.27	0.615	high	1
bb34f0f3-8759-4f51-8be3-ee2340db9806	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:53.163588	normal	fighting	0.74	t	Demo Camera	0.617	0.74	medium	1
85e5bfa0-4e27-40e3-9e78-caed136fda51	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:53.163622	normal	fighting	0.74	t	Demo Camera	0.617	0.74	medium	1
d70cd065-d8f7-476a-acf8-6344351576c8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:54.126279	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
117b5a2b-3225-4fc5-83fb-914521be902f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:54.126314	normal	fighting	0.749	t	Demo Camera	0.233	0.749	medium	1
c0518b55-618c-4369-bb4d-c7ff6e49a731	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:55.045626	normal	fighting	0.897	t	Demo Camera	0.344	0.786	medium	1
f0cb2650-ff5a-4bbe-97f0-b2f9f0dc8292	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:55.045665	normal	fighting	0.897	t	Demo Camera	0.344	0.786	medium	1
fede9ce0-2e5e-44cc-8047-0ca1100d4ed4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:56.07135	normal	fighting	0.577	t	Demo Camera	0.391	0.577	medium	1
371be65c-0864-48ad-8687-291a813db00b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:56.071391	normal	fighting	0.577	t	Demo Camera	0.391	0.577	medium	1
9ee902fc-f021-4ca5-8673-36c6a12ddd3f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:57.32437	car_crash	normal	0.749	t	Demo Camera	0.334	0.251	medium	1
664c47b2-9a9b-47a8-b1e5-0e2bc1b638e7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:34.401969	normal	normal	0.542	f	Demo Camera	0.542	0.211	low	1
e9a80b5a-89a9-4808-b8ad-557b01ab867b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:34.402007	normal	normal	0.542	f	Demo Camera	0.542	0.211	low	1
9597495d-ed83-43ff-bd26-660507b56f19	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:36.984509	normal	normal	0.766	f	Demo Camera	0.243	0.234	low	1
a3d21f5b-8f5b-4b5d-891d-d1bfc67a0677	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:36.984547	normal	normal	0.766	f	Demo Camera	0.243	0.234	low	1
0e34d4b0-7a22-4b5c-8c4c-e9f1193e7494	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:39.516203	normal	vehicle_intrusion	0.48	t	Demo Camera	0.48	0.318	medium	1
fed81ff0-7337-4016-8895-c03f8fe0d664	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:39.516258	normal	vehicle_intrusion	0.48	t	Demo Camera	0.48	0.318	medium	1
7d9a2bce-795b-4759-ad35-25da6424c7ad	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:13.274249	normal	normal	0.697	f	Demo Camera	0.391	0.303	low	1
84acb3d4-b1af-4d38-93fa-87f5fa620ed5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:13.274287	normal	normal	0.697	f	Demo Camera	0.391	0.303	low	1
32bba10c-141e-438d-9303-73e3a5509e25	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:15.89556	normal	normal	0.813	f	Demo Camera	0.435	0.813	low	1
67db2b2e-c0ff-433a-b5fc-39031d74a907	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:15.8956	normal	normal	0.813	f	Demo Camera	0.435	0.813	low	1
66615ddc-71f4-4eaf-8c0b-8be665eb57f6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:18.482515	normal	normal	0.781	f	Demo Camera	0.73	0.322	low	1
3bae2cd0-aa81-481b-8685-28286b590001	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:18.482551	normal	normal	0.781	f	Demo Camera	0.73	0.322	low	1
b6c0bb22-c5cb-4fcc-8c5e-529273abebbb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:27.429316	normal	fighting	0.406	t	Demo Camera	0.404	0.406	medium	1
28f25bfc-9004-4f71-b0d0-d46355d68725	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:27.429383	normal	fighting	0.406	t	Demo Camera	0.404	0.406	medium	1
d596f1e6-774e-4bd4-b023-4771facebb2d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:43.592338	normal	intruder_detected	0.907	t	Demo Camera	0.309	0.867	medium	1
53b0bfa4-497d-4ee4-ad0f-eec2954be0a9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:43.592413	normal	intruder_detected	0.907	t	Demo Camera	0.309	0.867	medium	1
80d406a4-7ea6-46f8-8f92-05cd6f121441	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:44.602308	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
ce3b24f2-a12f-41bd-af6d-67a7000afb18	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:44.602348	normal	fighting	0.553	t	Demo Camera	0.445	0.553	medium	1
feb6ab7f-32ab-4863-bb15-d0ebac1f8dc3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:45.573083	normal	robbery	0.438	t	Demo Camera	0.263	0.438	high	1
be87b704-0536-4215-b526-f4625fd9b8d6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:45.573162	normal	robbery	0.438	t	Demo Camera	0.263	0.438	high	1
e762cc11-4c11-46ca-a7c3-0fe41496ac2a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:46.546236	normal	fighting	0.655	t	Demo Camera	0.345	0.655	medium	1
d8a38e37-9c7e-410f-8839-dae1ed488861	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:46.546271	normal	fighting	0.655	t	Demo Camera	0.345	0.655	medium	1
bb6b1656-1ac9-4ba5-8010-025480b8a68f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:47.532591	normal	normal	0.764	f	Demo Camera	0.236	0.339	low	1
6127a19d-da20-46e7-9d20-303275790e76	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:47.53263	normal	normal	0.764	f	Demo Camera	0.236	0.339	low	1
952ee7a9-e6b7-434a-80ab-f18b7d153a5b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:48.523745	normal	normal	0.643	f	Demo Camera	0.551	0.357	low	1
dfa4e985-de14-4c52-ad80-1354231ff83c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:48.523785	normal	normal	0.643	f	Demo Camera	0.551	0.357	low	1
2c7f3c77-b8f9-4729-a84d-ea1f58fdd19b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:49.505416	normal	fighting	0.663	t	Demo Camera	0.242	0.663	medium	1
6a4538fe-4b08-4803-9183-da53451213c3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:49.50545	normal	fighting	0.663	t	Demo Camera	0.242	0.663	medium	1
5c7253e5-2bf9-4e74-8f19-746a19640f7a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:50.464749	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
6dd8b4a8-c14e-4faf-8ad1-26038fa88d0a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:50.464789	normal	fighting	0.521	t	Demo Camera	0.521	0.456	medium	1
15fb5352-e488-43b6-93f8-a09ae836ca25	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:51.440623	normal	normal	0.652	f	Demo Camera	0.35	0.348	low	1
09301540-68e9-432d-921f-5a18bad5c896	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:51.440663	normal	normal	0.652	f	Demo Camera	0.35	0.348	low	1
c394cbda-54bd-4d89-a779-eb243199a791	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:52.422619	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
694e79bd-5b43-4f4c-8feb-3c13dc7e7d57	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:52.422654	normal	fighting	0.921	t	Demo Camera	0.205	0.921	medium	1
8b7d82c8-e721-491f-b924-dc60a8ddd5b9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:53.416284	normal	fighting	0.86	t	Demo Camera	0.239	0.86	medium	1
3e713993-3fb6-4037-b49f-8709987e6eaf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:53.416324	normal	fighting	0.86	t	Demo Camera	0.239	0.86	medium	1
d12f6533-9bd1-4231-ab72-1fb787ec0069	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:54.344118	normal	weapon_detected	0.522	t	Demo Camera	0.522	0.503	high	1
cb099610-fc02-4241-8072-099d0cd11e57	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:54.344194	normal	weapon_detected	0.522	t	Demo Camera	0.522	0.503	high	1
ee20c2bb-2997-43dc-bcd5-fa4d315b1fed	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:55.307739	normal	forced_entry	0.677	t	Demo Camera	0.397	0.677	high	1
dae2e0b6-869d-4f15-b1f7-4b21388f0f2c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:55.307779	normal	forced_entry	0.677	t	Demo Camera	0.397	0.677	high	1
732b54ef-644c-4650-b97d-1f93a26d1f3b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:56.411605	normal	fighting	0.88	t	Demo Camera	0.4	0.599	medium	1
a6dcc2d6-5ec9-4e2e-ac00-4de705cc0313	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:56.411645	normal	fighting	0.88	t	Demo Camera	0.4	0.599	medium	1
44b6b0f8-fdf4-4f2e-8cc6-18ab61139c57	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:57.693119	normal	normal	0.44	f	Demo Camera	0.328	0.44	low	1
ae7d9029-53e7-4c17-a064-52c1978eb4e2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:35.000203	normal	robbery	0.391	t	Demo Camera	0.391	0.303	high	1
1a956504-e660-44d6-8994-4297d527885b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:35.000278	normal	robbery	0.391	t	Demo Camera	0.391	0.303	high	1
0e8f796f-c030-4150-af03-19e989ec8e11	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:37.613011	normal	normal	0.813	f	Demo Camera	0.435	0.813	low	1
c43953b6-ef37-47c9-b887-c350f4d451d8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:37.613052	normal	normal	0.813	f	Demo Camera	0.435	0.813	low	1
59af8737-effc-4e1b-86b2-e6c416b0a807	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:38:40.151602	vehicle_intrusion	vehicle_intrusion	0.37	t	Demo Camera	0.73	0.322	medium	1
9253f3d8-ce84-4bb4-b541-05eb67679821	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:38:40.15168	vehicle_intrusion	vehicle_intrusion	0.37	t	Demo Camera	0.73	0.322	medium	1
c8acfeff-4033-46f9-9ea9-5dfa814a5e6f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:13.956288	normal	normal	0.697	f	Demo Camera	0.4	0.303	low	1
00f6dd1d-0257-4a80-bcf5-b1a839c4e23f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:13.956324	normal	normal	0.697	f	Demo Camera	0.4	0.303	low	1
3192fc34-1ed2-46bb-8351-e4d098ece21a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:16.55215	normal	normal	0.686	f	Demo Camera	0.309	0.314	low	1
a81a255d-bf9f-4838-8d99-05206d24f46e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:16.552193	normal	normal	0.686	f	Demo Camera	0.309	0.314	low	1
da9a7121-96f2-40f8-b393-3cef790d1ea2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:26.518646	abuse	abuse	0.478	t	Demo Camera	0.874	0.416	high	1
d0b1cda0-f5c8-46d1-82a2-340e3a4ae25a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:26.518721	abuse	abuse	0.478	t	Demo Camera	0.874	0.416	high	1
8e326996-ce9e-40d4-bef3-e55ee4db8e49	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:27.711841	fight_sounds	weapon_detected	0.637	t	Demo Camera	0.406	0.441	high	1
8239024b-8473-4fdc-9e96-6eb7303acd2b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:27.711917	fight_sounds	weapon_detected	0.637	t	Demo Camera	0.406	0.441	high	1
c1538532-b799-41d2-b7c9-4750f02fce82	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:43.836789	normal	fighting	0.646	t	Demo Camera	0.601	0.646	medium	1
57dfb9a3-c584-47e2-902b-f17d4cc0d4ea	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:43.836865	normal	fighting	0.646	t	Demo Camera	0.601	0.646	medium	1
11f279c7-4125-4195-905d-38c755dbe2e1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:44.847335	normal	normal	0.84	f	Demo Camera	0.337	0.84	low	1
4cac7ea3-7df1-4095-87fa-7ab23332c230	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:44.847379	normal	normal	0.84	f	Demo Camera	0.337	0.84	low	1
93579ece-2cb4-44ee-a6d5-1b23fcee163c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:45.817568	normal	fighting	0.783	t	Demo Camera	0.615	0.783	medium	1
0dd4bfa8-25d8-4226-a8b7-7c016a8736bd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:45.817607	normal	fighting	0.783	t	Demo Camera	0.615	0.783	medium	1
64d79057-ca9f-4d92-bfa7-07b745f0f11e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:46.793159	normal	fighting	0.63	t	Demo Camera	0.452	0.63	medium	1
43e5e704-7790-4981-acb2-9100a3e7a708	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:46.793201	normal	fighting	0.63	t	Demo Camera	0.452	0.63	medium	1
417e8c09-75c7-4e49-aecd-390543e1b2f0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:47.78507	normal	intruder_detected	0.779	t	Demo Camera	0.49	0.779	medium	1
62acc663-54bd-4c3a-9dcb-f8107646098b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:47.78511	normal	intruder_detected	0.779	t	Demo Camera	0.49	0.779	medium	1
c898a2be-5bc9-4928-b0eb-e3f5d270cf7c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:48.765713	normal	normal	0.903	f	Demo Camera	0.323	0.357	low	1
486e39cb-d8e4-4ab4-8899-4523f25eb919	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:48.765758	normal	normal	0.903	f	Demo Camera	0.323	0.357	low	1
563fb4fd-bf37-4e46-ab02-5566ef01a5fb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:49.754863	normal	normal	0.62	f	Demo Camera	0.53	0.38	low	1
611077a2-3fd3-4635-8e1d-001e5d8fd468	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:49.754902	normal	normal	0.62	f	Demo Camera	0.53	0.38	low	1
0652caac-09a3-46c0-b7e0-51a8b8a52e36	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:50.715868	normal	fighting	0.713	t	Demo Camera	0.473	0.713	medium	1
a1e17a61-fce9-4643-8858-59d7705731b0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:50.715905	normal	fighting	0.713	t	Demo Camera	0.473	0.713	medium	1
18ad9e37-9bd4-479d-903d-f76be68378eb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:51.668743	normal	fighting	0.792	t	Demo Camera	0.627	0.792	medium	1
b056d244-91e8-432f-8753-65d9b7eb5ec2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:51.668777	normal	fighting	0.792	t	Demo Camera	0.627	0.792	medium	1
808e1d28-5e38-4a3d-9b1b-8a8949849398	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:52.674637	normal	fighting	0.682	t	Demo Camera	0.237	0.682	medium	1
13fae0b5-0237-4afd-9f73-638aab4ac2b0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:52.674672	normal	fighting	0.682	t	Demo Camera	0.237	0.682	medium	1
c9dbd04b-7df7-48c0-9df4-604c76878fea	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:53.661419	normal	fighting	0.86	t	Demo Camera	0.238	0.86	medium	1
debc429a-5c86-4c67-b27f-9b74ed37142d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:53.661458	normal	fighting	0.86	t	Demo Camera	0.238	0.86	medium	1
c5fab4ea-d354-4d8d-b55e-9259299e5696	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:54.579444	normal	fighting	0.585	t	Demo Camera	0.569	0.585	medium	1
9660d09b-8086-4c16-96b1-5c965ed594a9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:54.57948	normal	fighting	0.585	t	Demo Camera	0.569	0.585	medium	1
d54d3391-c709-46b0-a9d0-e1c4bd69d921	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:55.56946	normal	forced_entry	0.677	t	Demo Camera	0.652	0.677	high	1
379c9e6a-3768-488e-8bbc-97dbc33cff7a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:55.569499	normal	forced_entry	0.677	t	Demo Camera	0.652	0.677	high	1
0b664183-37db-4f74-b364-95616ca3e89e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-05 08:48:56.673479	normal	normal	0.804	f	Demo Camera	0.196	0.802	low	1
2830a74f-e4b3-4ef6-845e-175948c0cc99	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:56.673519	normal	normal	0.804	f	Demo Camera	0.196	0.802	low	1
7fc7016a-c238-4cbd-91b4-240e7033e2f0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:29:52.916537	normal	violence	0.99	t	Demo Camera	0.376	0.99	high	1
b7d773ce-7f1b-4535-9f34-25787201c003	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:57.324451	car_crash	normal	0.749	t	Demo Camera	0.334	0.251	medium	1
cd20cdf8-f952-47e9-8a83-c44ded34e892	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:29:52.916644	normal	violence	0.99	t	Demo Camera	0.376	0.99	high	1
48b85d92-7f00-429d-a4cd-986a629f4510	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:29:53.959772	normal	normal	0.804	f	Demo Camera	0.238	0.804	low	1
fdc551f7-e848-46ac-8ff1-ef644f6b58d5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:29:53.959809	normal	normal	0.804	f	Demo Camera	0.238	0.804	low	1
28783f3a-2b33-425c-aace-7b77cda56245	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:29:54.983258	impact	normal	0.773	t	Demo Camera	0.406	0.773	high	1
2b4af4a3-eb55-47bb-a043-2d5aabb8533f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:29:54.983335	impact	normal	0.773	t	Demo Camera	0.406	0.773	high	1
723242d7-8ef7-493a-9cd0-8ac0629f3d0f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:11.422142	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
f99d541b-fdaf-4eee-962f-11aeb8bec4e7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:11.422179	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
b4f0e533-51c2-437c-b207-caf043a14b03	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:13.068607	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
0f8b914b-05b3-4f65-bf38-f031f3fcba67	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:13.068647	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
b2cad6b0-8c6b-4e9e-b25f-fedcf90d8f3d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:16.452001	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
f93f15d4-26ae-40f0-aa4e-d5c118d6db1a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:16.452041	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
09639b51-51f9-4c14-90b2-10f6de6f65ff	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:58.994016	normal	violence	0.99	t	Demo Camera	0.271	0.99	high	1
d4269504-fc90-40ae-a6f5-19cd9cf9f631	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:58.994134	normal	violence	0.99	t	Demo Camera	0.271	0.99	high	1
bb20284e-70fb-42fd-a89d-126e6b7a5087	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:47:00.638256	normal	violence	0.99	t	Demo Camera	0.33	0.99	high	1
d298c011-7026-4c81-bd9c-dbeb545edf44	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:47:00.638462	normal	violence	0.99	t	Demo Camera	0.33	0.99	high	1
f3ece9cc-8b9d-4471-805c-a1c91eab1e67	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:06.573635	normal	normal	0.864	f	Demo Camera	0.216	0.864	low	1
56706675-e36e-4084-ac1e-80e967b33f6c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:06.573768	normal	normal	0.864	f	Demo Camera	0.216	0.864	low	1
1df7c971-8de0-411f-b65b-069b51b9eea2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:09.771954	normal	normal	0.83	f	Demo Camera	0.721	0.83	low	1
d9757c5a-4526-453c-92ad-9ba1ca716e89	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:09.772151	normal	normal	0.83	f	Demo Camera	0.721	0.83	low	1
465f6712-85af-44cd-aefc-c0c955ad230a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:12.997713	normal	normal	0.833	f	Demo Camera	0.297	0.833	low	1
4f7542ae-41f5-4c46-b21f-5665fe7887d9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:12.997909	normal	normal	0.833	f	Demo Camera	0.297	0.833	low	1
f218d733-8e47-46ff-a965-cd7ddbcb5eb6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:05.33754	normal	normal	0.811	f	Demo Camera	0.339	0.811	low	1
34af67a7-49d3-44cc-b42b-238f49c5dd45	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:08.74442	normal	weapon_detected	0.562	t	Demo Camera	0.182	0.562	high	1
800d2bea-2ff9-4de9-a820-05b1fd20f024	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:08.744594	normal	weapon_detected	0.562	t	Demo Camera	0.182	0.562	high	1
09b84aa0-6d99-4bbf-89e0-39296da58aa0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:27.289295	normal	weapon_detected	0.99	t	Demo Camera	0.183	0.99	high	1
799132ed-1ae1-461f-88c8-7cda14746055	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:27.289555	normal	weapon_detected	0.99	t	Demo Camera	0.183	0.99	high	1
42820f31-3e5b-4cdb-8b6d-a7be454e4ff4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:27.774652	normal	weapon_detected	0.99	t	Demo Camera	0.238	0.99	high	1
b06bac1c-1e21-40ce-95c2-cc430e3baf90	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:28.232453	normal	weapon_detected	0.904	t	Demo Camera	0.641	0.904	high	1
e61ba7f3-7b32-493e-b6b1-86383ea04bc8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:28.232638	normal	weapon_detected	0.904	t	Demo Camera	0.641	0.904	high	1
03164c0b-3daf-4051-a6ee-810196585c9f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:28.760054	normal	weapon_detected	0.981	t	Demo Camera	0.406	0.981	high	1
188634ef-007d-4313-9471-6a8f29bcb345	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:28.760143	normal	weapon_detected	0.981	t	Demo Camera	0.406	0.981	high	1
7c9890ef-7621-4887-8772-163a9b07ed5a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:29.234469	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.684	high	1
bf8b3399-47d4-46c4-ad9c-fc97691fb546	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:29.234582	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.684	high	1
aade4cc2-a287-411f-8168-d0f077d8489d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:39.641879	normal	normal	0.893	f	Demo Camera	0.261	0.893	low	1
95d70a4c-715d-4aef-a898-eb9edcc2f597	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:39.642101	normal	normal	0.893	f	Demo Camera	0.261	0.893	low	1
ab6c12f6-ede1-4766-8065-fe2957c3b9f0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:40.492883	normal	normal	0.845	f	Demo Camera	0.46	0.845	low	1
5e36e4ba-d17c-4a61-a42d-93004ee7a03d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:40.493119	normal	normal	0.845	f	Demo Camera	0.46	0.845	low	1
182fa3c8-519f-4292-b87f-29a80afe1c75	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:41.234651	normal	normal	0.864	f	Demo Camera	0.216	0.864	low	1
9844b751-f156-4215-b8d7-84f49fa370f7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:41.234816	normal	normal	0.864	f	Demo Camera	0.216	0.864	low	1
5379702f-5407-4165-8b96-225345f77990	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:42.080678	normal	normal	0.9	f	Demo Camera	0.441	0.9	low	1
86963602-e032-4592-a205-a9821ec60dd4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:42.080892	normal	normal	0.9	f	Demo Camera	0.441	0.9	low	1
a7048135-a972-4c61-ab32-32567d5d91b8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:42.836978	normal	normal	0.846	f	Demo Camera	0.771	0.846	low	1
033059a0-c94d-4707-9813-854f52e21d22	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:42.837215	normal	normal	0.846	f	Demo Camera	0.771	0.846	low	1
0d90dff2-2a9c-49a9-a357-57e128c4501b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-05 08:48:57.693158	normal	normal	0.44	f	Demo Camera	0.328	0.44	low	1
1cb0e57d-5107-45c5-b5bd-32c77c730b2c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:27:06.978497	normal	violence	0.99	t	Demo Camera	0.183	0.99	high	1
ad589a41-29fe-4e17-907b-e2b34acc15b7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:27:06.978727	normal	violence	0.99	t	Demo Camera	0.183	0.99	high	1
611ea1b4-1555-4035-ab96-d46490d49cd0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:27:08.490864	normal	intrusion_detected	0.878	t	Demo Camera	0.406	0.825	high	1
3711a85f-04f9-401a-9bfd-fa7dacfc3c36	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:27:08.490959	normal	intrusion_detected	0.878	t	Demo Camera	0.406	0.825	high	1
6b32eada-ff96-4a7e-b21b-ead2c4013520	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:27:39.809123	normal	intrusion_detected	0.99	t	Demo Camera	0.23	0.99	high	1
56050002-d3aa-4b50-a854-9a48cc57396a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:27:39.809277	normal	intrusion_detected	0.99	t	Demo Camera	0.23	0.99	high	1
661d7e05-d37e-4229-93be-f0bbf8f8f0bc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:27:40.685389	normal	intrusion_detected	0.806	t	Demo Camera	0.227	0.806	high	1
1a1aba16-6d4f-4b10-b284-d8375f7e1e94	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:27:40.685555	normal	intrusion_detected	0.806	t	Demo Camera	0.227	0.806	high	1
b0c2498e-18a2-4b36-82e4-f3dbba76ce8a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:27:41.490234	normal	intrusion_detected	0.7	t	Demo Camera	0.339	0.7	high	1
920c56dd-7b30-4a0b-9d6b-71ebaef735af	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:27:41.490342	normal	intrusion_detected	0.7	t	Demo Camera	0.339	0.7	high	1
e4e8da70-bc2f-4fa8-8e71-fca04c7608df	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:27:42.407548	normal	intrusion_detected	0.99	t	Demo Camera	0.339	0.99	high	1
85f0c35a-745a-4353-a62a-91c0c1fc224f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:27:42.40772	normal	intrusion_detected	0.99	t	Demo Camera	0.339	0.99	high	1
f3a216ae-cde1-4d0b-a458-2a8cf4476f96	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:27:43.245253	normal	intrusion_detected	0.987	t	Demo Camera	0.343	0.987	high	1
4b2c33e6-c4c8-4b96-a774-2da98c11aece	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:27:43.245366	normal	intrusion_detected	0.987	t	Demo Camera	0.343	0.987	high	1
adab8862-09e3-4eb3-a5c6-677428f49b0a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:27:46.588991	normal	vehicle_intrusion	0.846	t	Demo Camera	0.513	0.717	medium	1
eea9104c-1bf0-44e8-b358-835aa2c81052	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:27:46.589089	normal	vehicle_intrusion	0.846	t	Demo Camera	0.513	0.717	medium	1
e23f5648-42b1-4761-b87b-8be7740624ef	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:29:47.676009	normal	intrusion_detected	0.99	t	Demo Camera	0.23	0.99	high	1
cd02fde0-b446-4a45-96cc-7e045148cc81	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:29:47.676089	normal	intrusion_detected	0.99	t	Demo Camera	0.23	0.99	high	1
f90caac9-60f6-4c3a-a5a7-277c8dda7d64	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:29:48.545695	normal	intrusion_detected	0.806	t	Demo Camera	0.227	0.806	high	1
16e264ec-b15f-449f-9e3f-9a1ab13c4cf7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:29:48.54587	normal	intrusion_detected	0.806	t	Demo Camera	0.227	0.806	high	1
7ab80aee-1f44-4d6a-9969-6d7ddcbe207f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:29:49.365077	normal	intrusion_detected	0.7	t	Demo Camera	0.339	0.7	high	1
a548e5d5-e253-4468-be94-b97bf711172a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:29:49.36525	normal	intrusion_detected	0.7	t	Demo Camera	0.339	0.7	high	1
fb379b64-7426-4e2f-ba6f-7023c98e3dcf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:29:50.279199	normal	intrusion_detected	0.99	t	Demo Camera	0.339	0.99	high	1
05d6c478-1b0b-4570-a055-0168240584b3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:29:50.279363	normal	intrusion_detected	0.99	t	Demo Camera	0.339	0.99	high	1
a6f1bb9f-b16c-40ee-8a40-bbdcfa2a8cdf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:29:51.115196	normal	intrusion_detected	0.987	t	Demo Camera	0.343	0.987	high	1
e8b54555-eb62-42e6-bc85-12a024ef33f2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:29:51.115389	normal	intrusion_detected	0.987	t	Demo Camera	0.343	0.987	high	1
1ca1a079-da2c-436e-9bcd-3fab2ce5d919	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:29:54.430074	normal	vehicle_intrusion	0.846	t	Demo Camera	0.513	0.717	medium	1
0b62d0f1-b45a-491c-9e8b-4545d7b3b7e4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:29:54.430294	normal	vehicle_intrusion	0.846	t	Demo Camera	0.513	0.717	medium	1
b69625ac-8e27-4383-a45d-06a5aa0915c5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:30:09.764142	normal	intrusion_detected	0.99	t	Demo Camera	0.23	0.99	high	1
caa60113-fd7c-4d0e-af67-6970ecc7c21f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:30:09.764364	normal	intrusion_detected	0.99	t	Demo Camera	0.23	0.99	high	1
cdb8de90-a8cc-48fe-8c50-f04c0e9b512c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:30:10.644756	normal	intrusion_detected	0.806	t	Demo Camera	0.227	0.806	high	1
f65c80b3-c437-4524-8676-485e4b716a75	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:30:10.644838	normal	intrusion_detected	0.806	t	Demo Camera	0.227	0.806	high	1
554a8738-7d8c-4b2a-8653-fa07eb3d5261	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:30:11.451248	normal	intrusion_detected	0.7	t	Demo Camera	0.339	0.7	high	1
ab80c01f-acbe-4724-bbb8-05c21fd0893b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:30:11.451457	normal	intrusion_detected	0.7	t	Demo Camera	0.339	0.7	high	1
25992284-adec-4cf4-bc00-52453ba00939	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:30:12.365062	normal	intrusion_detected	0.99	t	Demo Camera	0.339	0.99	high	1
450358a6-cdc8-438f-be1d-548c19e59fe8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:30:12.365473	normal	intrusion_detected	0.99	t	Demo Camera	0.339	0.99	high	1
d6a68597-2333-47af-8464-0a3bc74614e8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:30:13.195687	normal	intrusion_detected	0.987	t	Demo Camera	0.343	0.987	high	1
8dc308e5-7048-4304-b365-8f4085950a77	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:30:13.195819	normal	intrusion_detected	0.987	t	Demo Camera	0.343	0.987	high	1
d65e7c71-7aa3-4a93-9bd6-a0b52e24e0b9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:30:16.604892	normal	vehicle_intrusion	0.846	t	Demo Camera	0.513	0.717	medium	1
9848bb09-b820-47a8-898a-7d5cd13ae148	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:30:16.605117	normal	vehicle_intrusion	0.846	t	Demo Camera	0.513	0.717	medium	1
9709f6d4-bac3-465a-bcca-007cc740ecf0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:41:38.400448	normal	normal	0.888	f	Demo Camera	0.227	0.888	low	1
cf54c0e4-77b1-4aff-a2e7-aabbaa77d607	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:41:38.400594	normal	normal	0.888	f	Demo Camera	0.227	0.888	low	1
ddda58de-132f-4ef6-874a-da0f89e8bc80	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:41:41.739717	normal	normal	0.93	f	Demo Camera	0.286	0.93	low	1
ca576e6f-78da-487f-b3ee-09c730c7b3ef	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:41:41.739929	normal	normal	0.93	f	Demo Camera	0.286	0.93	low	1
eecbd787-33a3-4e46-a19b-9be5b827b206	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:10.438263	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
ca9b0293-78d2-462f-9914-c2d5948c3de6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:10.438428	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
64ebba4e-5d75-400e-bd9e-0e9b31ce2e2f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:13.785403	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
9ec3c7b7-f2f3-4c9b-816f-6632e1d09205	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:13.785507	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
b4e4a9b8-c5bb-40bc-86d4-49263d7fd4a8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:17.222287	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
60fea0ec-dfb1-4093-9677-70626e314cbe	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:17.222441	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
4261042b-e87b-4063-a1f9-564293902eb9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:44:44.61692	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
7bb9c490-a753-4824-af05-38cec16d0185	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:44:44.617073	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
2c13bef5-3001-4fd4-9b2f-3c207cc1a98b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:44:47.976917	distress_sounds	normal	0.84	t	Demo Camera	0.84	0.767	high	1
09453018-4db8-4b52-88f7-df0dfcce0977	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:44:47.977006	distress_sounds	normal	0.84	t	Demo Camera	0.84	0.767	high	1
8fbd27ac-c71b-47e6-9006-de9267fad754	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:44:51.316543	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
3ff11489-93b6-4992-8a45-60cdccd9d78c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:44:51.316656	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
01c9c5f6-c2a6-4370-8d02-5c20921804db	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:14.708363	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
64a6f3ee-f68c-49b4-86dd-5d02f218349a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:14.708439	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
dffd1e0f-3e25-442d-b32f-42c7f774c1e1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:18.114874	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
d63111f9-ccf4-4a77-879f-1d63781852ca	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:18.115082	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
0163f357-71f6-420a-98aa-9eb2ba11b970	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:21.36067	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
3006faf3-d4c9-43b1-be2c-d736d4ca6237	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:21.360872	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
6e071369-31fb-4cfc-9172-69c5a376aaff	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:40.613522	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
50dff577-22c4-4d30-94f1-6e01e2e73231	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:40.613721	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
d8d053ba-2186-4f90-8a94-6690a3f4d610	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:46:27.957582	normal	normal	0.857	f	Demo Camera	0.543	0.857	low	1
0870b693-3dc6-4627-a2a5-1d709203579e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:46:27.957693	normal	normal	0.857	f	Demo Camera	0.543	0.857	low	1
bea74428-e53c-412e-b41d-2d5e3f6e4f40	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:29:54.434163	fight_sounds	weapon_detected	0.545	t	Demo Camera	0.641	0.626	high	1
73f9a1ce-f247-4f16-9114-be2d6fca53ab	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:29:54.434244	fight_sounds	weapon_detected	0.545	t	Demo Camera	0.641	0.626	high	1
c59104e6-76d9-41f9-aaf7-38baff89d5f0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:14.786333	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
3c759b89-0ae0-49e6-bb66-eee39e9b3ccc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:14.78638	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
4f6e58ab-0070-46b9-93e5-907730b84baf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:18.043325	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
0dcf0416-51df-4641-a89f-d2bbbd4985ce	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:18.043363	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
7a5267fc-c53d-4211-bcca-41dc553f67b6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:23.727227	normal	weapon_detected	0.99	t	Demo Camera	0.183	0.99	high	1
b0fa5709-bf8f-44e7-a70b-3466213f96e9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:23.727375	normal	weapon_detected	0.99	t	Demo Camera	0.183	0.99	high	1
ebb74bf2-9c30-4dad-824c-7e4304276dc2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:25.666762	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.684	high	1
c2b135ea-4bfa-4841-b3b6-769979c3d148	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:25.666917	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.684	high	1
3df02421-3d66-435b-8127-4b1da7607e71	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:49.806934	normal	normal	0.819	f	Demo Camera	0.227	0.819	low	1
8830b449-04a7-40fd-b7fd-d82cf70d3b73	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:49.807118	normal	normal	0.819	f	Demo Camera	0.227	0.819	low	1
4f7b01d5-5ded-4309-bc6d-5409340cfeab	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:53.150307	normal	weapon_detected	0.574	t	Demo Camera	0.286	0.574	high	1
277808a5-e73f-468a-8cbd-6b167d498470	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:53.150539	normal	weapon_detected	0.574	t	Demo Camera	0.286	0.574	high	1
d814a3d4-b89d-4bb9-a1e6-aebc7c59b264	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:01.779226	normal	normal	0.813	f	Demo Camera	0.212	0.813	low	1
e63c6a1a-2e6c-4577-ad97-cd49cd055444	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:01.779337	normal	normal	0.813	f	Demo Camera	0.212	0.813	low	1
0144b2b4-40de-4bbb-b7b3-96576de9bad7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:05.337313	normal	normal	0.811	f	Demo Camera	0.339	0.811	low	1
944be89f-6e1c-4b0c-b06f-4c6ad836a16e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:41:35.870353	normal	normal	0.846	f	Demo Camera	0.212	0.846	low	1
940a02dc-cf62-48d2-89db-09e36ca03752	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:41:35.870547	normal	normal	0.846	f	Demo Camera	0.212	0.846	low	1
7146c38f-adf5-4838-a6cb-532bbb1b57a0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:41:39.194139	normal	normal	0.906	f	Demo Camera	0.339	0.906	low	1
61ce0e79-04a6-4931-a764-cdefd2e244d2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:41:39.194342	normal	normal	0.906	f	Demo Camera	0.339	0.906	low	1
8c48d9cd-1f25-4591-91ef-8f47a984642c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:41:42.618893	normal	normal	0.838	f	Demo Camera	0.182	0.838	low	1
e3b981a3-7bf2-4348-8f69-ece92e62322d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:41:42.619102	normal	normal	0.838	f	Demo Camera	0.182	0.838	low	1
3c0729ac-0855-45e3-b35c-f99614f9e52f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:11.323171	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
8991f3a9-12f1-40b4-aef9-98cbbc74ea41	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:11.32325	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
037e0e49-a08c-4edc-87a4-53e5d8ca1e9d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:14.69819	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
5f221753-41c0-4493-9206-229141c929d3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:14.698282	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
3db9940b-15f5-480a-96bb-447ac2b63408	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:18.035234	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
b1c6a55d-78d1-4357-a3c9-b736cedecf5d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:18.035377	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
fcfc0afa-6064-415f-8848-b8c4861cd6b2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:44:45.398685	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
ae205860-feec-4afb-bf50-0ba1b1bbefb0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:44:45.398787	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
52330113-0d3a-4377-802a-d36eb19f63f8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:44:48.743476	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
692e5482-c697-4b21-9845-5f9dbd1c793c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:44:48.74357	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
3d15dafc-17b6-4372-9d60-9e88c95247ea	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:44:52.196929	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
a266f246-db3a-4ad6-b7e4-c6d82ce17ee5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:44:52.197012	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
fb18edea-f8e4-4494-af4e-94fc1bc1b2c4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:15.587105	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
b64c797b-30c9-4ba3-9785-ceb111da5d93	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:15.587306	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
c0f2bc1a-a2be-4290-949d-37874ce5521e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:18.9117	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
2c54086c-49a9-4b5f-885a-b74a9b9a2786	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:18.911864	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
f9dcaa6d-629c-4f5d-bf2a-2dd876268dec	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:34.921102	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
6bf16edd-b3a9-4b4c-bd70-9cec17dd7f03	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:34.921303	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
d03a1d07-52d1-45bb-ac56-04b312487a96	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:41.376544	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
f568c65e-893a-4416-8d00-f0613ef867a1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:41.376634	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
8b9b4dea-11ed-4d07-8078-e0369b4ace03	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:09.74033	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
ab6babdf-4231-45a5-8622-e84afaa77c37	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:09.740369	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
9dee8f42-fe8b-40a7-bbb0-224715b103c3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:13.972112	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
4eb82f68-deef-4e78-828f-fa6099b20ed0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:13.972144	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
c5891b5e-fb47-4ca6-8c43-3fbdee7807bc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:32:17.246997	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
f962703c-81e9-4909-a8f1-449004b4a07f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:32:17.247033	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
780118ba-e521-4d56-b771-c4b04a6b3ada	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:24.213187	normal	weapon_detected	0.99	t	Demo Camera	0.238	0.99	high	1
b85b1e15-8fe9-4aea-bd62-67d2faf1bcd6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:24.213296	normal	weapon_detected	0.99	t	Demo Camera	0.238	0.99	high	1
41bfd8db-3ec5-4a25-96ba-e4c381a3a342	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:47.283937	normal	normal	0.756	f	Demo Camera	0.212	0.756	low	1
69ef4e16-afdf-42ff-9111-a602af88083b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:47.284138	normal	normal	0.756	f	Demo Camera	0.212	0.756	low	1
ad05da1d-91b9-4ece-a507-bd57276f0e36	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:50.600259	normal	normal	0.785	f	Demo Camera	0.339	0.785	low	1
c84cc645-b56c-40ab-9977-4e89d99737d5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:50.600452	normal	normal	0.785	f	Demo Camera	0.339	0.785	low	1
4ec2c572-8de5-49dd-a9f2-07edd70da193	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 12:29:54.051152	normal	weapon_detected	0.562	t	Demo Camera	0.182	0.562	high	1
9327893d-246a-4127-a385-947286d7af7c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 12:29:54.051299	normal	weapon_detected	0.562	t	Demo Camera	0.182	0.562	high	1
e95fb63a-6d9f-43bf-9590-5ef4e2e3ed37	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:02.692874	normal	normal	0.825	f	Demo Camera	0.187	0.825	low	1
6d4fb2ba-ecd1-4154-bc52-53961f98aab5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:02.693084	normal	normal	0.825	f	Demo Camera	0.187	0.825	low	1
c0b6be17-a307-48b3-952f-dc3e0d7ca991	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:09.53422	normal	normal	0.541	f	Demo Camera	0.431	0.459	low	1
674997ff-3a2f-41be-b9c6-079cc3316374	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:09.53445	normal	normal	0.541	f	Demo Camera	0.431	0.459	low	1
a5948099-4545-45ec-8c1a-6460966a235d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:41:36.749867	normal	normal	0.873	f	Demo Camera	0.187	0.873	low	1
342aef9a-1230-4a8e-bd64-5ef43273ffbd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:41:36.750077	normal	normal	0.873	f	Demo Camera	0.187	0.873	low	1
f67f0416-2f2e-4f81-8e64-2e852a56647b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:41:43.416087	normal	normal	0.833	f	Demo Camera	0.431	0.833	low	1
8354ccf5-386c-4aa9-92a1-2d553cde15ef	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:41:43.416289	normal	normal	0.833	f	Demo Camera	0.431	0.833	low	1
b65a986e-1395-4716-ba09-8fe2e28ce2d7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:12.096603	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
03824856-4987-48ef-b33a-572818200ea0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:12.096843	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
137c87a0-d457-4933-ac79-dfb757b70332	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:15.530745	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
ccd8b9a1-2321-4ca9-8c3a-a8374a454e78	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:15.53083	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
5ae8374d-6eeb-4216-9527-9363ba989352	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:18.829457	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
c85b508c-c878-4506-af7c-57bb82306960	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:18.82961	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
24ac4a3a-a8fa-4766-9c5f-ee1b4d86c950	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:44:49.655704	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
c02ade99-afcd-4866-a564-0ab8761d6374	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:44:49.65582	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
1ca414d7-74ff-4251-9939-7e1db5056d12	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:13.052195	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
f952e74f-7d19-4276-ba6a-e03fcdcd6907	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:13.052295	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
950b31db-7f12-43fa-8a9a-3d911ceedfa6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:16.378639	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
3cc9fdf8-7151-4dc8-98ba-b8129f7a02c8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:16.378839	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
9d71ea92-20c9-4bf5-bd8f-fd2cbb65f014	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:19.784846	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
80304450-0507-474f-8b49-e1ecc4e1b733	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:19.785013	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
3447ab63-8732-4f91-8a32-bd5ce4ee833f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:35.797524	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
0fe213d6-ceda-49bd-b17a-2f96bdc325ed	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:35.797726	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
f851ff95-3674-4a88-993b-bc92842f9d55	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:39.032373	distress_sounds	normal	0.84	t	Demo Camera	0.84	0.767	high	1
436761c7-c0c4-478a-8e9f-a29d720ba7de	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:39.03257	distress_sounds	normal	0.84	t	Demo Camera	0.84	0.767	high	1
116e3eef-581d-4f91-810e-14170eff1ffd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:42.223917	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
bff9017b-8a89-40b6-9563-1cd05510a100	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:42.224115	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
e71d98dc-6a6a-403a-8d82-db2087f2bd9d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:46:28.992945	normal	normal	0.817	f	Demo Camera	0.183	0.816	low	1
2ae74bc2-5d41-420b-a598-90f9bc141437	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:46:28.993117	normal	normal	0.817	f	Demo Camera	0.183	0.816	low	1
3e8a826a-d853-4511-ad62-e08479d20f27	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:46:31.014785	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
9d9190e3-2043-454d-a5fd-3dee1e00faad	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:46:31.014953	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
380e1aaa-0f68-4b82-aec8-11454fe2ce0b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:52.175648	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
28273a18-552f-47fc-bfca-c7797c6498d4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:52.17611	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
a1643ebc-2a20-4caf-8194-213f6aa8fbcf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:55.432935	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
5c1c2a1e-04c9-449c-9187-34f1c950935e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:55.433141	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
07afe6bf-f27a-4d3a-b9c1-891b39ac996b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:58.803769	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
eee55cfb-0d56-4e5b-bb46-382e906ad963	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:58.803942	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
1a8472e9-8792-41e7-97b4-ff7bb88ccffc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:10.275267	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
f69be324-638f-4cf6-aa2b-c72a4192b0bc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:10.275451	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
490fa31c-0b4d-47bd-9349-89a9de2517b1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:13.465017	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
e611de5a-2826-4f3a-9c14-8539d4fb8ade	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:13.46523	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
8759d029-2b1d-4141-ab6d-cd00b02be477	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:16.676779	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
9be5ad0f-b218-4322-8e75-7748e75d902d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:16.676979	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
0626beeb-7557-44ac-88c5-7381a6ccefb5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:43.290458	normal	violence	0.99	t	Demo Camera	0.306	0.99	high	1
8be94dde-b3ea-43cf-beaa-7b903469d675	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:43.290608	normal	violence	0.99	t	Demo Camera	0.306	0.99	high	1
09f3c4c5-4952-413e-a140-f388236c2463	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:44.872171	normal	violence	0.99	t	Demo Camera	0.243	0.99	high	1
fb0442eb-0278-4cf6-b20c-343b35d7c6ba	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:44.872336	normal	violence	0.99	t	Demo Camera	0.243	0.99	high	1
4d2ed7b3-c245-4c08-998b-d0379edab8dc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:41:40.939194	normal	intrusion_detected	0.987	t	Demo Camera	0.343	0.987	high	1
c69e4137-efd1-4ec7-9742-4123a766bbe9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:41:40.939344	normal	intrusion_detected	0.987	t	Demo Camera	0.343	0.987	high	1
3e07bf79-0c37-40c9-b5c9-9ed4b88d6a81	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:41:44.221892	normal	normal	0.833	f	Demo Camera	0.513	0.833	low	1
24da2a0b-fccf-46c9-a5c0-48bb76415a91	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:41:44.222055	normal	normal	0.833	f	Demo Camera	0.513	0.833	low	1
eeb75af4-e1c7-4658-8cee-606c04d18692	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:12.964687	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
37f32432-df70-4803-bcbf-f7ce3eaea112	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:12.964813	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
b77c60e0-b0f4-481f-bc15-d3440d4d6f27	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:43:16.338939	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
9047ff44-60f0-4ab8-8c6a-0a9a6636dd4a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:43:16.33906	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
5c0a13df-3ec5-4f40-a939-2257b270f460	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:44:43.70024	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
e2a84cf4-c3ac-4305-86f4-5e6c386d6a6c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:44:43.700346	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
23b8d1ba-6a5a-4af3-b613-a6bc20bf8d9a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:44:50.456081	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
f5a572d4-51bd-4871-9a33-da45bb36ee31	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:44:50.456186	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
e9412252-0b14-492d-8083-df460683732f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:13.935423	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
de9eda49-716a-4d7e-863d-d3677d783668	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:13.935564	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
274495cd-6026-4299-a05a-b90b99c28a22	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:17.291293	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
54db9a3b-5984-484c-af5b-f07b3d931959	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:17.29147	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
61a6617c-878e-4466-af17-59d68faa7d9e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:20.577675	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
d18d4347-7f11-489d-b8d9-48ce89f8b543	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:20.577879	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
251fc1dc-328c-4312-905f-11fbb11866fe	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:36.541765	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
03710905-6e74-40f1-9d80-a0ab0b0e7d60	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:36.541965	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
639fc3f6-e208-42f2-bacf-9f78d5192888	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:39.780525	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
d930d8c1-c187-487d-852a-33b004a318c5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:39.780732	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
65460e7b-67fb-4c1a-82ef-c836bd088323	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:45:43.042482	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
81e4abe2-575b-444d-a4c9-760bc1ca28d4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:45:43.042682	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
66af486c-de70-4de7-96ed-c203ab7fb8ce	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:46:29.521025	normal	normal	0.804	f	Demo Camera	0.238	0.804	low	1
11d1aa83-8e17-4322-8913-f4bd9ec5f9e5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:46:29.521195	normal	normal	0.804	f	Demo Camera	0.238	0.804	low	1
731581c1-bc11-4060-a9c1-0a0928e835f3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:08.195393	normal	normal	0.782	f	Demo Camera	0.233	0.782	low	1
345551db-867d-4f6e-8dbb-cf2f49cf4afb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:08.195568	normal	normal	0.782	f	Demo Camera	0.233	0.782	low	1
6fcdb247-54ea-4d78-b612-14d01327449f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:09.020571	normal	violence	0.99	t	Demo Camera	0.24	0.99	high	1
3879eb8d-1598-4a8c-8c86-671a5842c364	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:09.020779	normal	violence	0.99	t	Demo Camera	0.24	0.99	high	1
42e0a109-9bc0-4741-a892-989fb388d934	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:09.436899	normal	violence	0.99	t	Demo Camera	0.186	0.99	high	1
5286f35d-9db6-470a-b1da-04e3ebede504	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:09.437064	normal	violence	0.99	t	Demo Camera	0.186	0.99	high	1
742bd98f-e990-4cf2-a0c7-1c13cbe26a89	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:09.868412	normal	violence	0.963	t	Demo Camera	0.443	0.963	high	1
8cf2db91-2279-4671-8ef3-9347dd8af642	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:09.868503	normal	violence	0.963	t	Demo Camera	0.443	0.963	high	1
3a22ff08-9c50-487b-97f6-17f8e24b5175	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:10.268362	normal	violence	0.99	t	Demo Camera	0.306	0.99	high	1
bae058de-2351-44f0-9237-2896b74554e1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:10.268447	normal	violence	0.99	t	Demo Camera	0.306	0.99	high	1
b132fb76-31c9-4b25-bfc4-c122020c302d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:10.691377	normal	violence	0.99	t	Demo Camera	0.304	0.99	high	1
ae349f96-b2af-4757-93bd-ad7eed3b914f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:10.691503	normal	violence	0.99	t	Demo Camera	0.304	0.99	high	1
b9419f2e-7338-49bf-83c3-83bc28a6e4ec	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:11.108129	normal	violence	0.99	t	Demo Camera	0.196	0.99	high	1
660a2191-d77a-491d-a41f-5f3030a4adf0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:11.108327	normal	violence	0.99	t	Demo Camera	0.196	0.99	high	1
fb94fb10-29ab-46f5-acb7-30bf0739cdb8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:11.508477	normal	normal	0.785	f	Demo Camera	0.215	0.509	low	1
4bda6a8d-cd13-492c-9814-e051e0167fb8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:11.508612	normal	normal	0.785	f	Demo Camera	0.215	0.509	low	1
c4f20467-563b-4b52-8bf0-f771b4241ef3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:11.920061	normal	violence	0.99	t	Demo Camera	0.243	0.99	high	1
4ec1e8b7-68e4-40eb-a07f-82eb846ab5f3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:11.920263	normal	violence	0.99	t	Demo Camera	0.243	0.99	high	1
b3305796-c01d-4213-8e73-e65de6c90813	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:13.181961	normal	normal	0.819	f	Demo Camera	0.181	0.775	low	1
00925f2c-db00-4a4b-8322-b37d2740928c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:13.182128	normal	normal	0.819	f	Demo Camera	0.181	0.775	low	1
482598e7-d673-44f3-abdc-b74dc8b38c28	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:14.860403	normal	normal	0.762	f	Demo Camera	0.386	0.762	low	1
3e7c2560-99ee-4f73-aa33-56bf29ac14ff	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:14.860504	normal	normal	0.762	f	Demo Camera	0.386	0.762	low	1
53e582f5-8b06-4c6c-b26d-f62cf9a5e3e1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:16.547254	normal	violence	0.986	t	Demo Camera	0.4	0.986	high	1
2fac7483-fccc-4312-a804-b46c2805a27e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:16.547399	normal	violence	0.986	t	Demo Camera	0.4	0.986	high	1
645caafa-d6cf-4af8-85e7-9543d7e26f20	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:18.276183	normal	violence	0.99	t	Demo Camera	0.192	0.99	high	1
82f61fdc-e5d7-466d-b17c-787d90104726	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:18.276355	normal	violence	0.99	t	Demo Camera	0.192	0.99	high	1
d24fd83b-a41b-4107-adf1-746e61ddb570	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:19.908359	normal	violence	0.99	t	Demo Camera	0.692	0.99	high	1
1614f3d9-b60d-4f85-adaa-824e0b8efec5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:19.908467	normal	violence	0.99	t	Demo Camera	0.692	0.99	high	1
bcfe44d9-1ea3-4972-be2a-83b416492966	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:21.559275	normal	weapon_detected	0.942	t	Demo Camera	0.462	0.942	high	1
92c47ff7-396d-40f9-8d5b-006b20a671c7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:21.559363	normal	weapon_detected	0.942	t	Demo Camera	0.462	0.942	high	1
43591066-b11a-444e-90f5-e90f69f06e94	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:23.275693	normal	violence	0.99	t	Demo Camera	0.346	0.99	high	1
f77b09a7-514e-46de-8a32-c90bca081d90	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:23.275807	normal	violence	0.99	t	Demo Camera	0.346	0.99	high	1
5b25e5b2-0b81-47dd-b6cf-81884e5ec492	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:25.005481	normal	violence	0.99	t	Demo Camera	0.267	0.99	high	1
0cc21360-a0f9-4a0a-a723-ad2654f74541	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:25.005594	normal	violence	0.99	t	Demo Camera	0.267	0.99	high	1
d6012135-4814-4b33-9f38-198e1c23d5d9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:26.553233	normal	violence	0.99	t	Demo Camera	0.762	0.99	high	1
efd84eab-27fe-4c4b-adc1-21998f62185e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:26.553356	normal	violence	0.99	t	Demo Camera	0.762	0.99	high	1
ff3157cb-2fe0-4c77-9b2f-dbd97a469c80	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:28.206716	normal	violence	0.99	t	Demo Camera	0.742	0.99	high	1
bffd3b81-0991-448b-ad4a-3a7cef40da8a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:28.206924	normal	violence	0.99	t	Demo Camera	0.742	0.99	high	1
fd36d693-f927-45f6-b19c-2b8290a9f7d9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:30.008743	normal	normal	0.804	f	Demo Camera	0.196	0.396	low	1
8e2f2663-593c-49f3-bf70-e0af05a5eb12	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:30.008911	normal	normal	0.804	f	Demo Camera	0.196	0.396	low	1
75f475cc-da2e-42a6-a9ed-d8cb99d12860	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:02.00707	normal	intrusion_detected	0.755	t	Demo Camera	0.339	0.755	high	1
45871104-6402-444e-a1c1-4a7dd883d401	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:02.007155	normal	intrusion_detected	0.755	t	Demo Camera	0.339	0.755	high	1
8241c613-911e-4d88-9f64-1407bb381ada	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:05.408159	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
2ec7a719-07bb-4cf3-a3de-a1dd250e7c9f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:05.408313	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
949f5e3d-bf43-4c7a-96bf-5405aceeeb35	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:32.633919	normal	intrusion_detected	0.771	t	Demo Camera	0.23	0.771	high	1
8990e49a-067f-483a-b4e9-7e38ba704c71	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:32.634027	normal	intrusion_detected	0.771	t	Demo Camera	0.23	0.771	high	1
2ecb7ee1-2f16-40e6-82ed-080ff9eb75f5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:36.181138	normal	normal	0.859	f	Demo Camera	0.343	0.859	low	1
b4d0b2cf-7857-4765-8f1a-aefa7b192f04	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:36.181298	normal	normal	0.859	f	Demo Camera	0.343	0.859	low	1
3c460457-ade2-4f5d-9f40-18065873637d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:39.630956	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
101cac5c-6187-41ec-bc79-a83c832e8dc1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:39.631207	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
a8bdc28b-b19f-40ea-865f-5e0bb633682e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:49.201766	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
989bd094-2b16-4227-8afc-6cd38f2fc423	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:49.201888	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
d1191e17-6dd0-4496-ad6c-8ecd2990608b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:53.049792	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
8af802d0-a389-41a9-a07c-64fd232bd140	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:53.049985	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
574abe20-7348-489a-8dfb-936f99114795	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:56.33125	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
3794fd93-b606-4b9e-a042-e3da2cd65582	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:56.331451	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
fe344cb7-4542-426f-b4c6-523a67e9cc43	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:59.585339	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
01158df8-8086-4f15-bc9a-c447f385e66f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:59.585504	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
5591c4cd-2efd-42f8-8f14-1c05a9a58ee0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:45:47.322339	normal	normal	0.817	f	Demo Camera	0.183	0.816	low	1
19afa789-bd30-4aa5-afbf-ac03122b0264	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:45:47.322494	normal	normal	0.817	f	Demo Camera	0.183	0.816	low	1
c9982623-681b-4628-a9fe-086481342062	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:45:49.252614	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
d246673f-862f-4fed-86da-b91f0fd45c16	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:45:49.252795	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
b58e7082-9cd6-4818-bd0b-3b0c6274bd36	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:13.6012	normal	violence	0.99	t	Demo Camera	0.191	0.99	high	1
81d25528-42af-4046-9f21-15cc025e09cb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:13.601342	normal	violence	0.99	t	Demo Camera	0.191	0.99	high	1
dc3d0e66-95c5-4b5f-8328-493b934b59fb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:15.275027	normal	normal	0.517	f	Demo Camera	0.373	0.483	low	1
04e03a4b-8323-4eaa-8ed6-90d60f9ac631	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:15.275155	normal	normal	0.517	f	Demo Camera	0.373	0.483	low	1
377ebe35-ef9d-494a-a636-62a2168c79ca	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:16.964357	normal	normal	0.802	f	Demo Camera	0.533	0.802	low	1
11062330-8f29-40e3-bf0c-703353c023d4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:16.964477	normal	normal	0.802	f	Demo Camera	0.533	0.802	low	1
8ee6a8ae-9c7c-4b06-af5c-671b5ab2f078	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:18.688434	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
63b2788e-effb-4276-817b-741d9f1d9ec5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:18.688549	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
62f61c90-63b6-465d-a951-7d01bb6868c2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:20.320928	normal	violence	0.99	t	Demo Camera	0.182	0.99	high	1
038219a8-1660-40f4-b8f7-b29f48e6dc9a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:20.321083	normal	violence	0.99	t	Demo Camera	0.182	0.99	high	1
fd78db76-2a08-4079-8a1b-9eb58eeea2bb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:23.710791	normal	violence	0.99	t	Demo Camera	0.531	0.99	high	1
35405f4d-82d0-4379-ad43-cfdd7ffe98d9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:23.710887	normal	violence	0.99	t	Demo Camera	0.531	0.99	high	1
c919dd13-6df4-4fd6-aaea-1a69a5d26031	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:25.399363	normal	violence	0.99	t	Demo Camera	0.29	0.99	high	1
2eb4bc7a-57fc-4500-8bcc-55b9012ac878	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:25.399517	normal	violence	0.99	t	Demo Camera	0.29	0.99	high	1
daeb6160-26bf-480d-97ac-88c7af20fec8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:26.952735	normal	violence	0.99	t	Demo Camera	0.271	0.99	high	1
5db53675-4249-42ed-980a-a8fcede90cd9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:26.952883	normal	violence	0.99	t	Demo Camera	0.271	0.99	high	1
b0142f3d-f9e8-40ef-8288-1abdb70790c3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:28.627012	normal	violence	0.99	t	Demo Camera	0.33	0.99	high	1
1999f4ab-6aeb-4457-a9a6-c7159eb79633	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:28.627225	normal	violence	0.99	t	Demo Camera	0.33	0.99	high	1
6fa83743-26c0-4655-928b-17d6322a6f90	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:49:59.353421	normal	intrusion_detected	0.771	t	Demo Camera	0.23	0.771	high	1
93377b96-ab60-46f6-83fe-82f75b038a5b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:49:59.353511	normal	intrusion_detected	0.771	t	Demo Camera	0.23	0.771	high	1
2c91c1a7-33de-4e75-b4d8-6d9cfb595b50	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:02.856171	normal	normal	0.859	f	Demo Camera	0.343	0.859	low	1
24472ee0-0aab-4385-953a-d33ebc69c56d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:02.85626	normal	normal	0.859	f	Demo Camera	0.343	0.859	low	1
29ce772a-ef8e-4750-ab10-9766ed3a0f95	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:06.214275	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
2b645cfd-6766-481c-8dc6-cfb994f15cb1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:06.21436	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
2443bc60-b0ac-470c-a567-6b30a60655d9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:33.526647	normal	intrusion_detected	0.604	t	Demo Camera	0.227	0.604	high	1
63c87714-998e-48d0-aefe-824333e5afe7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:33.526857	normal	intrusion_detected	0.604	t	Demo Camera	0.227	0.604	high	1
4f2e1c47-c1f5-4c77-ace1-1a3a6dd5ef55	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:37.028537	normal	normal	0.81	f	Demo Camera	0.286	0.81	low	1
e32ec3d8-52f8-45a9-ad20-4b936062a788	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:37.028647	normal	normal	0.81	f	Demo Camera	0.286	0.81	low	1
5d8922e6-fad6-4500-85c7-678434c2168a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:43.246258	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
16e9611f-fb43-4604-9ba2-cfa3ebc5f164	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:43.246355	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
581135bb-d357-4f7c-b1d6-915304ad4f51	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:49.972853	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
57a96d2b-9950-48fc-bda2-397f6bd1d8c6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:49.972937	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
0370dfa0-81fa-411d-9fb7-31ce3e663f3b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:53.804762	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
676ebcf4-baba-4223-935a-f68c5da6efd9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:53.804918	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
b97b6bcd-4f96-4442-9c50-9c831b8c1e2c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:57.149062	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
39895a58-dd81-4968-ab7f-82918a340acc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:57.149225	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
81e01c86-c994-4982-ae15-077d61c08a6a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:45:00.359468	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
a0c08b82-c1f1-48dc-a7e9-42ddbd9106ba	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:45:00.359669	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
231b6f6b-7e6b-41cf-9f74-87932f54b0fd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:45:47.799789	normal	normal	0.804	f	Demo Camera	0.238	0.804	low	1
d34bf322-42c4-4b54-a7c8-63259c884f41	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:45:47.79989	normal	normal	0.804	f	Demo Camera	0.238	0.804	low	1
8cffe51e-bc52-49eb-904e-1755f8c86c02	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:08.661824	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
1889d2fe-172b-45ad-96f5-9d8cbde47fca	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:08.661959	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
31114eeb-6ec6-48f3-9578-550817f69d5b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:15.039493	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
46370d9d-57d2-49ce-bc9b-dd56f5e09035	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:15.03969	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
b4fea263-76b4-44ec-b367-0ae7abe29478	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:14.027078	normal	violence	0.99	t	Demo Camera	0.327	0.99	high	1
6b1e4112-8938-47e1-a3f1-73ce1855a86c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:14.027202	normal	violence	0.99	t	Demo Camera	0.327	0.99	high	1
8a35f36c-1d57-4cd1-a363-86115886c9a8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:15.714438	normal	violence	0.99	t	Demo Camera	0.219	0.99	high	1
a506be01-da0d-4c27-84ea-abbbdece01e5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:15.71458	normal	violence	0.99	t	Demo Camera	0.219	0.99	high	1
8a2f6595-49bb-48cb-8ab0-0e6a31a563e3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:17.402994	normal	violence	0.886	t	Demo Camera	0.229	0.886	high	1
4826aeb5-dab9-4568-9016-d0e0ab279082	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:17.403087	normal	violence	0.886	t	Demo Camera	0.229	0.886	high	1
a17eb2a9-61de-47b4-bcb6-3363966e91a3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:19.090532	normal	violence	0.947	t	Demo Camera	0.457	0.947	high	1
1a74ba80-1ddc-4217-aa28-66b42c1cd92e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:19.090687	normal	violence	0.947	t	Demo Camera	0.457	0.947	high	1
34b9b258-9a71-4381-a172-fdc5a5e91efe	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:20.750892	normal	violence	0.99	t	Demo Camera	0.394	0.99	high	1
343ba305-532d-4805-8a11-5856c6f2ffcd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:20.750978	normal	violence	0.99	t	Demo Camera	0.394	0.99	high	1
4d869069-b614-46e3-9601-f1d22e213e70	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:22.406839	normal	violence	0.99	t	Demo Camera	0.193	0.99	high	1
3fc0fdf1-1454-409c-bb0a-a2c2daf2ec6b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:22.406951	normal	violence	0.99	t	Demo Camera	0.193	0.99	high	1
1f4abd6f-95a0-427c-8342-6c1c60e90e61	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:24.172248	normal	violence	0.99	t	Demo Camera	0.401	0.99	high	1
edf51e2a-e04f-4686-9499-1ce9fb2073fe	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:24.172334	normal	violence	0.99	t	Demo Camera	0.401	0.99	high	1
f0ce052b-8986-44b2-a644-0870cab83e7d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:25.776943	normal	normal	0.8	f	Demo Camera	0.2	0.503	low	1
612b4297-9045-48d4-8c55-98c6eaa3520a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:25.777143	normal	normal	0.8	f	Demo Camera	0.2	0.503	low	1
cb9e9e45-dbf6-4f20-9f84-7a9eaa4e857f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:27.38326	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
fe77c7d5-aeea-4b4c-ab4f-dd10be99a61d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:27.383471	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
393db7ad-566c-4d32-acf6-30adbd746421	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:29.103553	normal	violence	0.99	t	Demo Camera	0.216	0.99	high	1
0a476e94-25f4-49c4-97b0-0ebbdcd31ea6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:29.103716	normal	violence	0.99	t	Demo Camera	0.216	0.99	high	1
e901e878-4568-4624-8757-6589ae703956	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:30.987051	impact	normal	0.681	t	Demo Camera	0.501	0.681	high	1
3c234e71-d0c7-4183-87f0-250488d8586f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:30.987256	impact	normal	0.681	t	Demo Camera	0.501	0.681	high	1
e4d23483-6000-4f85-bb78-9874ea5a0d8c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:00.249457	normal	intrusion_detected	0.604	t	Demo Camera	0.227	0.604	high	1
ce8cf090-0f0c-4ccf-b414-6bcc7f46e9ad	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:00.249557	normal	intrusion_detected	0.604	t	Demo Camera	0.227	0.604	high	1
8020bce3-b2e1-4adc-83f4-1b679891c204	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:03.674162	normal	normal	0.81	f	Demo Camera	0.286	0.81	low	1
cb3d6e66-27fd-43af-9a1e-78e777ccf40d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:03.674259	normal	normal	0.81	f	Demo Camera	0.286	0.81	low	1
3bd06f64-9692-4438-b18d-de0a18035153	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:34.374501	normal	normal	0.513	f	Demo Camera	0.339	0.487	low	1
55d2009e-2ad6-4dab-9252-b31b4583b200	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:34.374585	normal	normal	0.513	f	Demo Camera	0.339	0.487	low	1
1c8053f0-0546-4b03-a980-be8e3339289f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:37.972142	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
ce7d471e-3133-4e95-9861-e1788ad57911	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:37.972228	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
a4d7dadb-9894-4d9c-9a8f-2b272d72aff8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:44.141005	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
3b545a3e-7c7c-48ef-8b40-c364d473af95	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:44.141156	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
158c90a5-340f-47d0-bd13-eaee8f303317	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:47.572161	distress_sounds	normal	0.84	t	Demo Camera	0.84	0.767	high	1
5ba9ddc0-8e28-40ff-8008-a406e6a9a341	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:47.572356	distress_sounds	normal	0.84	t	Demo Camera	0.84	0.767	high	1
2e419881-cd5d-47c6-989f-56540e96adaf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:50.835132	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
c753b170-e7e2-4aac-8092-914dd6b97619	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:50.835234	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
aaba641d-6aaf-4b81-a72a-a3af123e6bda	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:56.107143	normal	violence	0.817	t	Demo Camera	0.183	0.791	high	1
e0164c62-8766-48e0-9e99-0be41edf2365	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:56.107234	normal	violence	0.817	t	Demo Camera	0.183	0.791	high	1
934650c4-6442-4be1-932c-fdc09291d50b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:58.069622	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
ddadf9bc-6965-42f3-b9fb-70723f77887a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:58.069766	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
ee36fb9e-0c3b-489d-ae1d-ea37a966fdb0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:54.653287	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
b151f43b-b186-4368-a195-c43aa40f172a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:54.653492	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
3b37ec91-9a25-44db-9ec8-aca87e3b91ac	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:44:57.94034	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
4bd8db4e-8f98-45c4-81b2-285cd6ec6c53	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:14.434798	normal	violence	0.99	t	Demo Camera	0.38	0.99	high	1
0c6d2932-d276-4142-abd5-624b5008ee4b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:14.434889	normal	violence	0.99	t	Demo Camera	0.38	0.99	high	1
53ab6675-a623-4ac7-922c-267013192f77	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:16.132085	normal	violence	0.99	t	Demo Camera	0.283	0.99	high	1
cee8cf0b-1959-4955-a065-3822ea26bf1b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:16.132168	normal	violence	0.99	t	Demo Camera	0.283	0.99	high	1
7b6f4ef5-1cf5-4d7c-8051-4a924e872c44	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:17.859276	normal	violence	0.851	t	Demo Camera	0.229	0.851	high	1
00b500c3-f1ac-4eef-bed2-999c3288c687	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:17.85943	normal	violence	0.851	t	Demo Camera	0.229	0.851	high	1
d30706a3-bcd1-431d-bf2b-6ae1f2f2e9d7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:19.499062	normal	violence	0.936	t	Demo Camera	0.329	0.936	high	1
2e1fd991-03c5-4abd-aac7-f5b4802f7ba6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:19.499179	normal	violence	0.936	t	Demo Camera	0.329	0.936	high	1
d7a43a03-d1b9-4c29-a749-d815bffb62e2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:21.151892	normal	violence	0.99	t	Demo Camera	0.353	0.99	high	1
5ecc4d36-362a-495f-a440-6a3f4ea1c8cc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:21.152021	normal	violence	0.99	t	Demo Camera	0.353	0.99	high	1
7ea81fcf-0aaa-4692-b2d1-a7ecd22db712	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:24.599144	normal	violence	0.99	t	Demo Camera	0.197	0.99	high	1
1fb2d49e-7f0f-4e93-b16d-1bdb510de7f2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:24.599256	normal	violence	0.99	t	Demo Camera	0.197	0.99	high	1
25ce9913-ba76-41a0-967e-6c031ab37cab	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:26.164021	normal	violence	0.99	t	Demo Camera	0.341	0.99	high	1
6b95edbe-fcb1-4bb2-b7b6-05a45d4cb61f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:26.164219	normal	violence	0.99	t	Demo Camera	0.341	0.99	high	1
190a8284-f1ab-41b5-882d-9364147eff3a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:27.798722	normal	violence	0.92	t	Demo Camera	0.267	0.903	high	1
5a3e924c-4a74-4131-9506-772d72bbdd3f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:27.798888	normal	violence	0.92	t	Demo Camera	0.267	0.903	high	1
9caeded3-1858-4174-8f5c-9773888d53f3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:47:29.530651	normal	violence	0.99	t	Demo Camera	0.749	0.99	high	1
8127d22e-4590-4424-8d4a-9aab39897579	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:47:29.530853	normal	violence	0.99	t	Demo Camera	0.749	0.99	high	1
1d41baed-65ce-4655-9610-2740e02f6f78	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:01.072713	normal	normal	0.513	f	Demo Camera	0.339	0.487	low	1
699186e3-99e9-49b5-a888-60d9d05c115a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:01.072805	normal	normal	0.513	f	Demo Camera	0.339	0.487	low	1
70101808-842c-47eb-aaae-84b96675b255	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:04.572685	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
9400b303-35d3-4dab-a555-a7378b3c3645	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:04.572796	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
1a13812f-f767-47cd-b1e6-d5f06ad53ec9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:35.316212	normal	intrusion_detected	0.755	t	Demo Camera	0.339	0.755	high	1
063a8206-377b-47bf-9443-4a669117ab66	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:35.316328	normal	intrusion_detected	0.755	t	Demo Camera	0.339	0.755	high	1
4015c6b9-4100-4c7c-971c-994ea9053d09	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:38.814931	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
36dfd996-e90a-485c-a7d1-fbdd1ea08e5b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:38.815048	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
61b00b75-581a-41f2-9f92-f41c88befdfc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:44.957177	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
8835cffe-ac4e-49c8-bd68-c7bb3dc0687c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:44.957267	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
6ac0335c-3786-49fe-b5df-bb8b56aa96bf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:48.341954	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
88538c5f-7ef8-4896-be8d-064c81b92de7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:48.342037	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
09147319-351d-4381-b16d-88c03354adf0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:51.681883	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
6782acbb-83da-4ff6-b4ab-0e3a8c52fc35	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:51.682008	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
ff8b8a06-9987-4777-afa9-e5d3ffac0823	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:50:56.605123	normal	normal	0.796	f	Demo Camera	0.238	0.796	low	1
770f6486-9fcc-470a-b7d3-11e2e746eed9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:50:56.605213	normal	normal	0.796	f	Demo Camera	0.238	0.796	low	1
c0a9a78c-7e77-4a52-90bd-572e1f73c2a3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:32.61712	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
2b4203f8-44c3-4600-ba70-a94cadb0bc7e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:32.617313	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
33c55b3b-9b8e-40e8-92fb-c5dc18909218	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:33.498446	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
3171161f-e02e-4c5e-9c93-1c70eb18167c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:33.498664	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
333f70af-260b-4f40-a4dd-91c362ab6cdf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:34.260079	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
0d450ce6-df6b-4299-8eef-854ef7626a1d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:34.260224	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
1a9e03bd-b4d6-43a3-b5e7-c4b81993e4dd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:35.118397	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
a9f5626f-4d24-495a-ab42-ddd580b59c24	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:35.118597	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
d6aec092-225a-498d-9a7a-d82292379f28	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:35.907099	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
451f9c2e-8b03-488e-87ca-813956720d67	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:35.907248	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
5f3e698b-d0d7-4884-889a-2b9f61f1c085	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:36.828489	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
2bc20988-39a6-403a-8732-a0c6968715ac	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:36.82864	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
1fe3bc8c-43d3-4078-9a33-5446cb91f8ae	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:40.128275	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
cdf48e20-b3c1-4057-aca1-69d32f309437	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:40.128464	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
ef9f2f78-49f8-40de-a13b-e261e675ca3e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:07.762343	normal	normal	0.817	f	Demo Camera	0.183	0.816	low	1
7c3eb33d-cb74-436e-818f-361884411f69	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:07.762461	normal	normal	0.817	f	Demo Camera	0.183	0.816	low	1
e96606de-6f30-44e1-82f5-43b4f3ccfb87	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:09.744205	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
f051c169-2896-47e8-8662-73fad5964658	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:09.744383	normal	normal	0.811	f	Demo Camera	0.465	0.811	low	1
2a8a0a76-0b82-4607-b713-186c7c272c78	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:26.244362	normal	violence	0.99	t	Demo Camera	0.306	0.99	high	1
0b7c4a7b-fcf6-4bae-a39a-dad4b61c7f94	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:26.244592	normal	violence	0.99	t	Demo Camera	0.306	0.99	high	1
fba07926-5c9c-4d4c-b7cc-b1ee5f099fd6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:27.922563	normal	violence	0.99	t	Demo Camera	0.243	0.99	high	1
6699b56b-ca81-4504-b5c8-0deae7142ae2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:27.922766	normal	violence	0.99	t	Demo Camera	0.243	0.99	high	1
9ec7a0f1-4000-4e4e-94a4-5831db1875b7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:29.56844	normal	violence	0.99	t	Demo Camera	0.191	0.99	high	1
cc2d1a03-cb51-4c91-a5f7-8c4e3e100fb9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:29.568606	normal	violence	0.99	t	Demo Camera	0.191	0.99	high	1
898e7ddd-49f3-4267-87b3-7cc5b15aca5c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:31.161634	normal	normal	0.517	f	Demo Camera	0.373	0.483	low	1
c7730e04-d0c8-46d2-8116-90fa99018086	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:31.161835	normal	normal	0.517	f	Demo Camera	0.373	0.483	low	1
215748d1-7bc6-461b-b166-41a562de7526	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:32.731305	normal	normal	0.802	f	Demo Camera	0.533	0.802	low	1
f25f4e86-1dbb-4613-becc-1f66354a08d8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:32.731476	normal	normal	0.802	f	Demo Camera	0.533	0.802	low	1
cd0cacc4-57fa-461b-a798-79e4fe921b50	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:34.369527	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
a33658f2-4e4e-4233-b6d9-872fabc3e916	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:34.36973	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
3c242ada-7064-4e56-9a33-1051c87c7c8c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:35.960961	normal	violence	0.99	t	Demo Camera	0.182	0.99	high	1
8f97a82c-3884-47c6-bb79-ba4e06206f0b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:35.961173	normal	violence	0.99	t	Demo Camera	0.182	0.99	high	1
06f659cb-0a51-4f7f-9f07-6e8e3cbfe7c6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:39.266948	normal	violence	0.99	t	Demo Camera	0.531	0.99	high	1
47a22b26-af33-4605-95b5-5dc1a490c254	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:39.267158	normal	violence	0.99	t	Demo Camera	0.531	0.99	high	1
a5ddd3f7-3e4d-4b15-9b87-09444582b96c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:40.880061	normal	violence	0.99	t	Demo Camera	0.29	0.99	high	1
73884d91-6188-4d25-b7d5-09164643eece	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:40.880207	normal	violence	0.99	t	Demo Camera	0.29	0.99	high	1
c2365f0d-83fa-4b73-afa6-e6dac51dfe55	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:42.394774	normal	violence	0.99	t	Demo Camera	0.271	0.99	high	1
047c575d-4977-41cf-b716-1bb694fe7a34	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:42.394915	normal	violence	0.99	t	Demo Camera	0.271	0.99	high	1
b36017f9-f81f-4134-9043-5cf6b6861bfc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:44.079243	normal	violence	0.99	t	Demo Camera	0.33	0.99	high	1
89c4d1b4-c036-44b3-9352-0da2267880b4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:44.079395	normal	violence	0.99	t	Demo Camera	0.33	0.99	high	1
7fcefbdf-15fb-4b8a-850e-c59e8e509286	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:54:02.129496	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
46cbb11c-12e8-49b1-8ef3-6ffaebbe32dd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:54:02.129673	normal	normal	0.801	f	Demo Camera	0.216	0.801	low	1
408a8115-6733-48ed-b9f4-b248ac05e6bf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:54:05.324523	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
bc4a46ab-ca51-4757-9c77-e3562b106d8f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:54:05.324717	normal	normal	0.816	f	Demo Camera	0.721	0.816	low	1
da197c4c-24fa-4d2f-a366-ddaf8584cf6d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:54:08.541262	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
b1dbaf4b-4646-45c3-a9ff-9d0cfa045e25	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:54:08.541466	normal	normal	0.847	f	Demo Camera	0.297	0.847	low	1
7bf1774b-b7e0-4bb5-aa8e-ed64cc237aa5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:42.40673	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
3e2c250c-14f6-42fa-95db-e5490289d372	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:42.406933	normal	normal	0.871	f	Demo Camera	0.227	0.871	low	1
9e345dd1-c297-4f88-b879-3863cc19a873	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:45.804036	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
016e6da7-ae80-45a1-a65b-a75b8e62c991	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:45.804223	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
bbb46ad4-6e09-43e4-8e90-aeb76347257a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:44:57.940539	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
757a86c3-75c0-4c63-95f6-ff411ee92bc4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:45:46.358841	normal	normal	0.857	f	Demo Camera	0.543	0.857	low	1
6e7effe6-a49c-4978-bcea-ac813b75e62f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:45:46.35904	normal	normal	0.857	f	Demo Camera	0.543	0.857	low	1
7b5412b6-e9b9-481d-91f9-ad5d9038c7c9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:09.502594	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
d42f3339-a482-4774-ba17-83f6ecaf2f6c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:37.653256	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
4de803b4-788a-40d1-b88b-033999020448	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:37.653427	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
240c2640-f909-4e89-a8fe-0bdcb6f44929	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:40.913203	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
aaab174f-4d5a-476f-8a30-7ce45f8f1ced	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:40.913406	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
7be08186-f36b-4967-8006-5db2f581cebb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:08.258552	normal	normal	0.804	f	Demo Camera	0.238	0.804	low	1
2db440ff-9eff-48fc-8692-5ab749c93ea0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:08.258735	normal	normal	0.804	f	Demo Camera	0.238	0.804	low	1
d4b94861-4946-472f-8a1c-e7690c454af9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:24.983373	normal	violence	0.99	t	Demo Camera	0.24	0.99	high	1
80929304-b5b6-4b6c-a150-ddd5c77d6a49	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:24.983552	normal	violence	0.99	t	Demo Camera	0.24	0.99	high	1
8c87a99d-dc5e-486c-b393-fb704183e0e8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:26.652069	normal	violence	0.99	t	Demo Camera	0.304	0.99	high	1
6be61d60-21e5-43df-968c-f1d31632df53	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:26.652251	normal	violence	0.99	t	Demo Camera	0.304	0.99	high	1
d99176b1-8875-4773-bc0f-790651c9933d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:29.968379	normal	violence	0.99	t	Demo Camera	0.327	0.99	high	1
63224acd-6101-43ce-858f-871f83e95953	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:29.968564	normal	violence	0.99	t	Demo Camera	0.327	0.99	high	1
6ccbb414-f620-4abc-b886-5524f0402129	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:31.560521	normal	violence	0.99	t	Demo Camera	0.219	0.99	high	1
2d045e62-7827-4e87-a31f-5055205d69de	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:31.560686	normal	violence	0.99	t	Demo Camera	0.219	0.99	high	1
346e4b07-6fb9-4c1c-8154-74ea5bf0acf5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:33.154543	normal	violence	0.886	t	Demo Camera	0.229	0.886	high	1
3e8dfd27-4fc0-443c-a5d2-75c6d9065f85	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:33.154717	normal	violence	0.886	t	Demo Camera	0.229	0.886	high	1
a21dd4ec-a6f5-483a-b086-1198307c9866	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:34.756897	normal	violence	0.947	t	Demo Camera	0.457	0.947	high	1
4067a694-87db-4dc6-bd55-99dd59db50dc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:34.757103	normal	violence	0.947	t	Demo Camera	0.457	0.947	high	1
5c5ae4fb-39f4-4dac-b89a-10ab6aa5aabb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:36.367766	normal	violence	0.99	t	Demo Camera	0.394	0.99	high	1
1563eb9a-be5a-4fce-ad79-01ac46022f9c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:36.367879	normal	violence	0.99	t	Demo Camera	0.394	0.99	high	1
3b24a06b-a25f-4087-9bc4-96948b8c0069	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:37.994687	normal	violence	0.99	t	Demo Camera	0.193	0.99	high	1
cf13f7ab-16b3-4418-9d6b-d0873aa00d35	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:37.994864	normal	violence	0.99	t	Demo Camera	0.193	0.99	high	1
1aebc829-b8be-470f-94b5-d6873b45e1dc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:39.679844	normal	violence	0.99	t	Demo Camera	0.401	0.99	high	1
b27a3890-8091-4a21-8d69-bc642c3adacd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:39.679995	normal	violence	0.99	t	Demo Camera	0.401	0.99	high	1
fa3c3090-eb3d-4327-b4ce-0e933e16bf0b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:41.233601	normal	normal	0.8	f	Demo Camera	0.2	0.503	low	1
9220c4d0-1c24-45f7-8ee8-1269d9a942d1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:41.233798	normal	normal	0.8	f	Demo Camera	0.2	0.503	low	1
3acc8eaf-47c8-428f-980b-25c5bcb365db	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:42.816448	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
855d94c2-a2cc-46a6-953b-25d57aeee36d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:42.816612	normal	violence	0.99	t	Demo Camera	0.199	0.99	high	1
389c522b-bbff-4f53-98ca-c434ea11a1ba	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:44.558484	normal	violence	0.99	t	Demo Camera	0.216	0.99	high	1
f3442257-a3d3-4247-abba-77be0e44f998	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:44.558666	normal	violence	0.99	t	Demo Camera	0.216	0.99	high	1
093a5f03-2a75-4b3e-acb1-d26d1673ea23	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:46.4858	impact	normal	0.681	t	Demo Camera	0.501	0.681	high	1
73ad2a32-eb46-45e0-b7e4-074f26f5d450	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:46.48606	impact	normal	0.681	t	Demo Camera	0.501	0.681	high	1
4ad021fd-8d06-4853-bbbd-1dcc0142a2a8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:54:06.156697	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
4b2f0d25-cb7a-4e78-b5c3-9753b2627499	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:54:06.156892	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
a8056180-c75e-4600-a229-941eecbf5308	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:39.913615	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
59cd2b9c-72cf-4ba7-ae89-8b8d3fea053f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:39.913708	normal	normal	0.817	f	Demo Camera	0.212	0.817	low	1
46d98438-bbfb-4e13-9147-0403e85f6481	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:43.210241	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
4fc1442f-39ba-404d-9c03-a722668d2c0a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:43.210393	normal	normal	0.861	f	Demo Camera	0.339	0.861	low	1
61c01121-6dd6-415b-8327-d1ac18a46dfd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:46.679556	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
73f9a212-8e86-4ece-a7e4-bfa148cb2516	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:46.679755	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
f5ca1840-f7c9-4ae4-96ca-44a792b0eaf0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:09.502742	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
d1b1d933-49c4-4b4b-bdb0-244e4dd8a8bf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:12.724851	distress_sounds	weapon_detected	0.714	t	Demo Camera	0.84	0.767	high	1
ed0967d5-157b-4e52-b60e-243da0336059	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:12.725008	distress_sounds	weapon_detected	0.714	t	Demo Camera	0.84	0.767	high	1
01e17dfa-36d4-4e27-be8b-ed1f21e4b8ce	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:15.869569	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
fa32b427-e23c-420a-ab59-6b7e6e1233d5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:38.446556	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
0f343891-d5ba-48e4-9d08-97c486dc687e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:38.446727	normal	normal	0.863	f	Demo Camera	0.286	0.863	low	1
2ec9c8ee-9df8-4597-b132-a6a74855a038	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:06.750233	normal	normal	0.857	f	Demo Camera	0.543	0.857	low	1
4df08d8a-04da-4a89-8612-3480152d7774	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:06.750392	normal	normal	0.857	f	Demo Camera	0.543	0.857	low	1
c9c9a927-9347-41cc-a813-0aedeecdbebb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:25.405563	normal	violence	0.99	t	Demo Camera	0.186	0.99	high	1
5bd24133-1461-4230-861d-fa2c6ccfefc0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:25.405776	normal	violence	0.99	t	Demo Camera	0.186	0.99	high	1
4a85be1c-fda0-4571-a981-c42ce2e3669d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:27.075768	normal	violence	0.99	t	Demo Camera	0.196	0.99	high	1
0c1a99c8-7829-45ce-9e5c-c777e26cc26d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:27.075913	normal	violence	0.99	t	Demo Camera	0.196	0.99	high	1
cc930b79-329d-4b10-85df-33541329463e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:30.356143	normal	violence	0.99	t	Demo Camera	0.38	0.99	high	1
e45c7404-28c4-4c08-bc98-c79f26e1642e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:30.356348	normal	violence	0.99	t	Demo Camera	0.38	0.99	high	1
c78d4b6f-9d5a-4dc2-b8d3-a0ec67da04a7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:31.955651	normal	violence	0.99	t	Demo Camera	0.283	0.99	high	1
af0a8b87-5031-459e-ade7-fb5eb62052a6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:31.95586	normal	violence	0.99	t	Demo Camera	0.283	0.99	high	1
73885609-1368-4d8d-9517-3ca265145ff8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:33.556905	normal	violence	0.851	t	Demo Camera	0.229	0.851	high	1
4cc38f62-99c8-4611-860c-0682c97ee09b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:33.557092	normal	violence	0.851	t	Demo Camera	0.229	0.851	high	1
f05ba793-894f-4cd1-9f23-daac55e67c5a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:35.168604	normal	violence	0.936	t	Demo Camera	0.329	0.936	high	1
81d83914-de52-4b60-93fc-be85ced123ed	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:35.168816	normal	violence	0.936	t	Demo Camera	0.329	0.936	high	1
dbb900f5-f577-443a-b2b9-3a99853b8a4e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:36.770834	normal	violence	0.99	t	Demo Camera	0.353	0.99	high	1
069fbc88-d6f4-4952-9de1-0e694936df02	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:36.770986	normal	violence	0.99	t	Demo Camera	0.353	0.99	high	1
a8371dd5-dfaa-4262-b222-aec4d5391c9b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:40.07787	normal	violence	0.99	t	Demo Camera	0.197	0.99	high	1
0d00036c-2bbe-4491-bcc0-a52ed7c810e4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:40.078032	normal	violence	0.99	t	Demo Camera	0.197	0.99	high	1
7f6e8e67-af52-4543-a477-8bf785146e83	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:41.616877	normal	violence	0.99	t	Demo Camera	0.341	0.99	high	1
b6485f6d-07df-4c42-976c-c55d87eceaa5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:41.617074	normal	violence	0.99	t	Demo Camera	0.341	0.99	high	1
6e38da81-0abb-403a-9c86-44c7ba16412d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:43.247156	normal	violence	0.92	t	Demo Camera	0.267	0.903	high	1
cf176fb5-9b56-4b94-ac07-540fc1ac47c1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:43.247236	normal	violence	0.92	t	Demo Camera	0.267	0.903	high	1
a714da48-1226-4edc-b7e4-b5c98cd0a4cd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:44.995053	normal	violence	0.99	t	Demo Camera	0.749	0.99	high	1
719f2651-191f-4325-ab0b-7dc040cb8d2d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:44.995219	normal	violence	0.99	t	Demo Camera	0.749	0.99	high	1
6b3f0bb7-71e1-4662-b744-d38e10c5fbd4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:54:00.540519	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
f027b056-4070-474c-8571-a1704730f46c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:54:00.54073	normal	normal	0.835	f	Demo Camera	0.261	0.835	low	1
cdac9038-b26a-488c-b0f8-24c7946d9387	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:54:06.902008	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
d9da632c-fbf9-457e-bb42-c63ab3c58624	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:54:06.902194	normal	normal	0.838	f	Demo Camera	0.802	0.838	low	1
5fc2c824-2a6f-4bde-a2a9-fecd947742a4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:40.794908	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
c5e4cfa4-2a28-4b21-b7bb-a42c5b2ec434	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:40.795067	normal	normal	0.839	f	Demo Camera	0.187	0.839	low	1
f4054501-512c-4822-9852-22200f88034a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:44.140765	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
2e2ed332-ced2-4498-9a89-721471c6bc44	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:44.140967	normal	normal	0.824	f	Demo Camera	0.339	0.824	low	1
d8e0e0f8-a488-4483-80f4-f8f01eda1399	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:47.473016	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
2719f9df-1088-4256-95ea-97d12f3c54b5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:47.473173	normal	normal	0.829	f	Demo Camera	0.431	0.829	low	1
68244596-c5d1-4c01-98d5-2775e2024c9a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:14.299763	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
75d69133-cf38-4a43-94b4-00071ec5fbd3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:14.299922	normal	normal	0.822	f	Demo Camera	0.79	0.822	low	1
f5c396f9-fe92-4895-879f-0772b7f77a31	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:42.102072	normal	violence	0.99	t	Demo Camera	0.24	0.99	high	1
7416c421-378e-4308-9d93-b8a93a535abc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:42.102282	normal	violence	0.99	t	Demo Camera	0.24	0.99	high	1
19512bfc-295f-4738-aa3d-2b7eb6dcf01f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:43.682877	normal	violence	0.99	t	Demo Camera	0.304	0.99	high	1
62fe3588-2db6-4f4c-aa6f-0844d1bb3129	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:43.683027	normal	violence	0.99	t	Demo Camera	0.304	0.99	high	1
b90cdcf5-f03c-4fc3-a210-550e2ddbadea	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:46.861121	normal	violence	0.99	t	Demo Camera	0.327	0.99	high	1
8c88d316-964c-4908-b124-ac203337caab	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:46.861273	normal	violence	0.99	t	Demo Camera	0.327	0.99	high	1
26c2ae16-b925-4de0-a6c5-23aff7fcdf2a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:52:39.322515	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
4fedb046-51f9-4a8b-b0cd-220308f7eb8f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:52:39.322707	normal	normal	0.829	f	Demo Camera	0.182	0.829	low	1
63344be9-ba8e-4a96-9b35-c5eb8d98227d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:24.166899	normal	normal	0.782	f	Demo Camera	0.233	0.782	low	1
823ab4cd-9b59-4d42-a270-671e69bd10d3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:24.167086	normal	normal	0.782	f	Demo Camera	0.233	0.782	low	1
13327a35-8ea3-44c9-a8bf-8eec87088692	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:25.818904	normal	violence	0.963	t	Demo Camera	0.443	0.963	high	1
2bd8ef7e-3114-4f17-a331-0f8940a24e52	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:25.819078	normal	violence	0.963	t	Demo Camera	0.443	0.963	high	1
c81755cb-6692-4865-9810-c2ccf79f1301	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:27.500195	normal	normal	0.785	f	Demo Camera	0.215	0.509	low	1
dcd0fe91-f930-4ff1-89ff-9399b4b97e7d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:27.500306	normal	normal	0.785	f	Demo Camera	0.215	0.509	low	1
344eae29-2076-4921-9ba4-8599b71d6bd4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:29.167288	normal	normal	0.819	f	Demo Camera	0.181	0.775	low	1
396931e6-b962-403a-bd8e-03a033df7c06	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:29.167485	normal	normal	0.819	f	Demo Camera	0.181	0.775	low	1
a484c4a2-4113-4e13-9d9b-9b980177e403	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:30.749573	normal	normal	0.762	f	Demo Camera	0.386	0.762	low	1
3a70584c-dedf-4835-8fbc-dd3cc3760637	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:30.749775	normal	normal	0.762	f	Demo Camera	0.386	0.762	low	1
fda9341f-6d56-4195-aa6a-b744766c4d42	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:32.343042	normal	violence	0.986	t	Demo Camera	0.4	0.986	high	1
d5b4459f-6347-4036-9e0b-c889adfc0f76	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:32.343243	normal	violence	0.986	t	Demo Camera	0.4	0.986	high	1
8c3d3760-1a02-4954-8698-0af3d156b6ef	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:33.957426	normal	violence	0.99	t	Demo Camera	0.192	0.99	high	1
0b33fd2d-1364-4524-835d-bd3889c59e76	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:33.95761	normal	violence	0.99	t	Demo Camera	0.192	0.99	high	1
39875721-644d-4692-a9fd-8adeddd21192	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:35.564745	normal	violence	0.99	t	Demo Camera	0.692	0.99	high	1
ddbc004c-1c03-4fea-a9b0-8e22e66a2cd5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:35.564959	normal	violence	0.99	t	Demo Camera	0.692	0.99	high	1
3eaf4602-ebaa-40a4-b0d9-edef1de12a18	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:37.166991	normal	weapon_detected	0.942	t	Demo Camera	0.462	0.942	high	1
d42d77dc-8355-42ac-b895-513973e00a02	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:37.167144	normal	weapon_detected	0.942	t	Demo Camera	0.462	0.942	high	1
4cb29cce-efe5-48c9-962c-a05a23ab35c9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:38.86582	normal	violence	0.99	t	Demo Camera	0.346	0.99	high	1
ef33664e-fd45-4f06-8c28-ef62f771987c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:38.866015	normal	violence	0.99	t	Demo Camera	0.346	0.99	high	1
88ce2e49-c55a-45ef-a0ab-76e2131c7ac1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:40.49592	normal	violence	0.99	t	Demo Camera	0.267	0.99	high	1
89245a29-35a0-45a6-a1d3-93cbb88de700	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:40.496136	normal	violence	0.99	t	Demo Camera	0.267	0.99	high	1
fef2a285-b547-49da-8a5c-b4ffd8f57c28	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:42.004292	normal	violence	0.99	t	Demo Camera	0.762	0.99	high	1
8e6ca91b-95eb-4412-9210-dd6bed11c715	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:42.004496	normal	violence	0.99	t	Demo Camera	0.762	0.99	high	1
63280371-3cd4-4086-8b8a-c0bb9ef3c01f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:43.656772	normal	violence	0.99	t	Demo Camera	0.742	0.99	high	1
3a6238ee-bd71-4925-8f2d-8945fee7304b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:43.656927	normal	violence	0.99	t	Demo Camera	0.742	0.99	high	1
833f38e4-7d6b-47d3-8b8c-9cd558c2711b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:53:45.466001	normal	normal	0.804	f	Demo Camera	0.196	0.396	low	1
24394dc7-0c34-4a0e-b419-9d2a0cfad2bf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:53:45.466227	normal	normal	0.804	f	Demo Camera	0.196	0.396	low	1
02303c87-5b1c-44f0-91f4-7ba9be3d5b81	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:54:01.384473	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
6bacaf62-ac22-4a6f-a6ff-985aa36dcdc8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:54:01.384675	normal	normal	0.808	f	Demo Camera	0.46	0.808	low	1
b727bcfb-6b58-40a9-be3d-5e63c3637e5e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:54:04.577853	distress_sounds	weapon_detected	0.714	t	Demo Camera	0.84	0.767	high	1
bb51e68d-9a26-442b-b4db-886cd46fa7a0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:54:04.577948	distress_sounds	weapon_detected	0.714	t	Demo Camera	0.84	0.767	high	1
0dc51bdc-3d34-4761-b9a2-18c7759d4477	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:54:07.734743	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
24d92b30-3839-45fb-84e2-5bacc2d021af	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:54:07.73494	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
aa666a58-f1ed-4b80-bb71-9fb0d4fac2ee	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:41.552513	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
36c59285-4e28-41a1-aca3-3ecb8806bdf2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:41.55271	normal	normal	0.837	f	Demo Camera	0.23	0.837	low	1
14c49f0d-3d2a-4590-ac1b-fc51c688503b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:45.006631	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
0d1d130d-3e1e-45f9-b491-b221d0da87f9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:45.006792	normal	normal	0.854	f	Demo Camera	0.343	0.854	low	1
02b69d94-b84c-4562-a862-9fac727fd964	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-12 09:59:48.279637	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
99475cef-3e60-4da3-9b0c-9366568adf4d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-12 09:59:48.279764	normal	normal	0.829	f	Demo Camera	0.513	0.829	low	1
51c1226e-6287-47f7-a7a5-bb21c57d3c5a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-13 07:46:15.869773	normal	normal	0.845	f	Demo Camera	0.75	0.845	low	1
1bfcc9f8-8f3b-4cad-adc2-0adb67e7da13	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-13 07:46:41.311521	normal	normal	0.782	f	Demo Camera	0.233	0.782	low	1
94f2219a-1e76-4889-a6c8-edac140800ea	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:43.690267	normal	normal	0.838	f	Demo Camera	0.84	0.838	low	1
7bc3c58d-4c6f-4a7b-abc4-32bc5fa6bbc2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:43.690556	normal	normal	0.838	f	Demo Camera	0.84	0.838	low	1
ddb39fbb-5c20-44b7-8507-5531f2a84ddf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:46.849257	normal	normal	0.832	f	Demo Camera	0.75	0.832	low	1
85d7193d-b7c7-47cd-8435-cabeefd54a01	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:46.849483	normal	normal	0.832	f	Demo Camera	0.75	0.832	low	1
a1ba9aed-c414-43de-994f-4fa36ff9efcf	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:46:55.462138	normal	normal	0.817	f	Demo Camera	0.23	0.817	low	1
963b3e7e-132e-4046-b758-604da6ca434b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:46:55.46223	normal	normal	0.817	f	Demo Camera	0.23	0.817	low	1
80d52195-3d5d-4cff-8f85-bbb616d47720	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:47:02.302048	normal	normal	0.804	f	Demo Camera	0.513	0.804	low	1
41d6d859-2567-45ae-866d-c964a5e78568	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:47:02.302136	normal	normal	0.804	f	Demo Camera	0.513	0.804	low	1
ea88b42e-6f52-4490-8e03-9b36542fd961	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:47:26.760906	normal	weapon_detected	0.99	t	Demo Camera	0.238	0.99	high	1
da11d4f0-155c-41c6-b485-b0b3a00a0f7f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:47:26.761049	normal	weapon_detected	0.99	t	Demo Camera	0.238	0.99	high	1
537bc7a8-c666-4ddb-abf2-dbdb4eb26c98	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:23.12985	normal	car_crash	0.99	t	Demo Camera	0.771	0.99	medium	1
97f89aac-349d-4cbf-b362-2fd8f38d8059	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:23.130007	normal	car_crash	0.99	t	Demo Camera	0.771	0.99	medium	1
2790c786-23ac-47a7-bfe6-d18ceffe5d8b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:26.320842	normal	car_crash	0.99	t	Demo Camera	0.802	0.99	medium	1
1fe6c603-3b0e-48b1-84a1-1101db8cecfb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:26.320998	normal	car_crash	0.99	t	Demo Camera	0.802	0.99	medium	1
d972bcbd-59f4-4e64-9e0f-d72264dc341d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:39.766173	normal	weapon_detected	0.99	t	Demo Camera	0.406	0.99	high	1
365d7012-162b-4335-b7c0-04dfb9681c68	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:39.766316	normal	weapon_detected	0.99	t	Demo Camera	0.406	0.99	high	1
6929674b-04cb-40a8-894c-58542b93adfa	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:55.876426	normal	weapon_detected	0.993	t	Demo Camera	0.343	0.993	high	1
ebcb4224-f1fd-4411-a2d2-22373b5cfa87	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:55.876582	normal	weapon_detected	0.993	t	Demo Camera	0.343	0.993	high	1
1a39b468-7575-4ff0-aae2-9c2f08652954	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:39.081977	normal	weapon_detected	0.99	t	Demo Camera	0.322	0.99	high	1
80de36ab-0f02-4f83-8345-57a8069c7e71	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:39.08213	normal	weapon_detected	0.99	t	Demo Camera	0.322	0.99	high	1
8499dd32-a3bb-41d0-9b4c-0ddc36a89770	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:40.710361	normal	weapon_detected	0.99	t	Demo Camera	0.306	0.99	high	1
5f349d18-109f-48f4-851b-b60820b8fa09	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:40.710569	normal	weapon_detected	0.99	t	Demo Camera	0.306	0.99	high	1
57fb8187-de0a-4431-96b4-7d1f6bcfcf76	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:42.290366	normal	weapon_detected	0.99	t	Demo Camera	0.243	0.99	high	1
26f850cb-5fe4-4dbe-ac99-f4909747b77d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:42.29058	normal	weapon_detected	0.99	t	Demo Camera	0.243	0.99	high	1
4eb2e094-53c7-491f-9a8c-58beea47c4b6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:43.903744	normal	weapon_detected	0.913	t	Demo Camera	0.191	0.913	high	1
e1859860-de39-453a-b48e-abd0480910c8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:43.903943	normal	weapon_detected	0.913	t	Demo Camera	0.191	0.913	high	1
ccca81b8-9856-46e9-b941-0e4293418a71	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:45.516647	normal	weapon_detected	0.777	t	Demo Camera	0.373	0.777	high	1
67cf7f4d-eeec-422e-8adf-f6bf9d2d6c0f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:45.516795	normal	weapon_detected	0.777	t	Demo Camera	0.373	0.777	high	1
d98344fe-7085-46e9-8761-3721ffb907da	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:47.081255	normal	weapon_detected	0.761	t	Demo Camera	0.533	0.761	high	1
72b6b5ff-fea9-4e74-879a-9af1e7eb0d1c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:47.081407	normal	weapon_detected	0.761	t	Demo Camera	0.533	0.761	high	1
b20cba98-64cf-4ebf-8885-f149aa781415	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:48.68675	normal	weapon_detected	0.896	t	Demo Camera	0.199	0.896	high	1
c4418868-314a-480c-ae5a-3395d9143ca1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:48.68683	normal	weapon_detected	0.896	t	Demo Camera	0.199	0.896	high	1
e3436dd6-a199-4a52-8137-712dd546253e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:50.251343	normal	weapon_detected	0.888	t	Demo Camera	0.182	0.888	high	1
8d5aa693-bab6-405c-b7f3-e478f589c88d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:50.251546	normal	weapon_detected	0.888	t	Demo Camera	0.182	0.888	high	1
47da161a-e2d8-4c5d-96fd-fe8854325f99	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:51.826132	normal	weapon_detected	0.906	t	Demo Camera	0.37	0.906	high	1
5842eef8-210b-4ce5-93f4-1319aa9117bd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:51.826337	normal	weapon_detected	0.906	t	Demo Camera	0.37	0.906	high	1
54af7281-b7a9-462d-b729-ba656f17b419	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:53.4846	normal	weapon_detected	0.99	t	Demo Camera	0.531	0.99	high	1
a08801d7-334f-43f4-a55e-26bab0f6080a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:53.484779	normal	weapon_detected	0.99	t	Demo Camera	0.531	0.99	high	1
87c009e2-4896-4d37-9170-1af0d3705874	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:55.080675	normal	weapon_detected	0.99	t	Demo Camera	0.29	0.99	high	1
4a08a2c7-c6c8-4a54-99df-f7825b77a551	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:55.08076	normal	weapon_detected	0.99	t	Demo Camera	0.29	0.99	high	1
7f7fee07-9aba-4f60-bbe8-e69334467c6f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:44.431079	normal	normal	0.83	f	Demo Camera	0.721	0.83	low	1
acec4c27-bfd3-43e2-8bd9-544ff8c43c9f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:44.431299	normal	normal	0.83	f	Demo Camera	0.721	0.83	low	1
a0fe2400-b030-43db-94c1-09a233f63f15	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:47.664258	normal	normal	0.833	f	Demo Camera	0.297	0.833	low	1
030e20e5-2ac1-4030-ba72-bfcf47015395	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:47.664437	normal	normal	0.833	f	Demo Camera	0.297	0.833	low	1
068891dc-227f-45fa-ab98-a69b5704b4f5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:46:56.337064	normal	normal	0.782	f	Demo Camera	0.227	0.782	low	1
ba412848-16c6-4291-8c31-9ea1277fffbc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:46:56.337158	normal	normal	0.782	f	Demo Camera	0.227	0.782	low	1
2d821701-88f0-458f-b3ea-ce3f225c0c5a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:46:59.755572	normal	normal	0.803	f	Demo Camera	0.286	0.803	low	1
355d3483-0e78-44d4-99fb-690e63f96dd9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:46:59.755723	normal	normal	0.803	f	Demo Camera	0.286	0.803	low	1
8004e401-109a-44fb-b804-72d2251360c1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:47:27.248219	normal	weapon_detected	0.983	t	Demo Camera	0.641	0.983	high	1
8d25fd6a-d16c-47ea-8ba4-eb98fbac8def	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:47:27.24839	normal	weapon_detected	0.983	t	Demo Camera	0.641	0.983	high	1
85902671-4270-49f8-8c8b-705aeb2270c3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:27.154578	normal	car_crash	0.99	t	Demo Camera	0.75	0.99	medium	1
0c7bfff9-7bf3-46fc-8ed1-a8b9ac005609	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:27.154689	normal	car_crash	0.99	t	Demo Camera	0.75	0.99	medium	1
bff2485b-ce09-430d-aaab-43d3bdee7a11	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:38.276702	normal	weapon_detected	0.99	t	Demo Camera	0.183	0.99	high	1
e9e53d56-cfbc-451c-842a-908f59a5514a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:38.276841	normal	weapon_detected	0.99	t	Demo Camera	0.183	0.99	high	1
ac69b417-b97c-44d2-a8e6-28284d755cf4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:40.216753	normal	weapon_detected	0.99	t	Demo Camera	0.465	0.99	high	1
7b60468b-631d-4751-94a1-33470653db79	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:40.216876	normal	weapon_detected	0.99	t	Demo Camera	0.465	0.99	high	1
78a2f376-0856-42e3-a906-77208923fa34	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:56.673821	normal	weapon_detected	0.953	t	Demo Camera	0.286	0.953	high	1
bcd517c8-519e-4af0-90bb-d3d4860d99db	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:56.673969	normal	weapon_detected	0.953	t	Demo Camera	0.286	0.953	high	1
2699aa49-79f7-4fa0-8548-eeef2015d1ca	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:39.494354	normal	weapon_detected	0.99	t	Demo Camera	0.24	0.99	high	1
bfc1d33a-980b-43e7-9b3d-1ba3fba1b0e0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:39.494612	normal	weapon_detected	0.99	t	Demo Camera	0.24	0.99	high	1
05524833-81ee-4e79-984a-2a74c5b3c9dd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:41.107916	normal	weapon_detected	0.99	t	Demo Camera	0.304	0.99	high	1
81ed813b-d8e0-4a67-bf6e-28221f329c1f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:41.108065	normal	weapon_detected	0.99	t	Demo Camera	0.304	0.99	high	1
e9fa9f9b-6405-439d-a91c-f42333af475c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:42.68365	normal	weapon_detected	0.99	t	Demo Camera	0.202	0.99	high	1
d9b55da8-cc31-4a4c-bb68-8a7abb80fe1e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:42.68383	normal	weapon_detected	0.99	t	Demo Camera	0.202	0.99	high	1
d65df5ea-fcd3-4551-ac19-9c53c56adc5f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:44.306835	normal	weapon_detected	0.99	t	Demo Camera	0.327	0.99	high	1
93533cac-dbe0-40ce-a135-ca2778309abd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:44.307014	normal	weapon_detected	0.99	t	Demo Camera	0.327	0.99	high	1
751559ee-8567-43a1-8b24-3ee9c9c81987	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:45.914768	normal	weapon_detected	0.937	t	Demo Camera	0.219	0.937	high	1
64239311-33d7-4968-a6fe-a2820cba95fb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:45.914928	normal	weapon_detected	0.937	t	Demo Camera	0.219	0.937	high	1
7f423918-742d-419e-bb94-087f28caec6a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:47.498714	normal	weapon_detected	0.99	t	Demo Camera	0.229	0.99	high	1
b67d9972-494a-4cff-8756-bc368a6acf66	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:47.498869	normal	weapon_detected	0.99	t	Demo Camera	0.229	0.99	high	1
53907fde-9686-438f-9e32-e6df4938dd67	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:49.076946	normal	weapon_detected	0.99	t	Demo Camera	0.457	0.99	high	1
00bd04b0-04cc-4716-a468-333ac7f24ab1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:49.077098	normal	weapon_detected	0.99	t	Demo Camera	0.457	0.99	high	1
3e68a3c2-e97a-41cd-b63c-e0d4e0716f53	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:50.648255	normal	weapon_detected	0.99	t	Demo Camera	0.394	0.99	high	1
1aed6cc6-6310-465f-adf9-27748441d013	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:50.648414	normal	weapon_detected	0.99	t	Demo Camera	0.394	0.99	high	1
390ec9fe-94eb-4507-9db3-3df0cd2966d9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:52.24189	normal	weapon_detected	0.731	t	Demo Camera	0.193	0.731	high	1
96bc1eff-b2d9-416e-8c38-e1d55d7149ae	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:52.242096	normal	weapon_detected	0.731	t	Demo Camera	0.193	0.731	high	1
3b58b2ce-48b5-47fa-8213-c48ecdcee0e2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:53.899704	normal	weapon_detected	0.99	t	Demo Camera	0.401	0.99	high	1
2be8e404-258f-4aec-bf5e-990ec8cfdffa	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:53.899907	normal	weapon_detected	0.99	t	Demo Camera	0.401	0.99	high	1
90ebecfb-9997-463e-bd06-77bee1b2ebca	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:55.43469	normal	weapon_detected	0.99	t	Demo Camera	0.2	0.99	high	1
0f2d6e95-970b-4efb-97a5-d3173a92602d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:55.43486	normal	weapon_detected	0.99	t	Demo Camera	0.2	0.99	high	1
70149bf7-b6e8-4ee1-ad39-46f8b8cce796	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:45.268801	normal	normal	0.841	f	Demo Camera	0.79	0.841	low	1
b7f1b413-c7df-4f61-b2df-b43d3b8eb794	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:45.269037	normal	normal	0.841	f	Demo Camera	0.79	0.841	low	1
777869f2-5340-4836-baa3-fce3a66301b3	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:46:53.766364	normal	normal	0.813	f	Demo Camera	0.212	0.813	low	1
afbf3a81-efb4-4faa-ada9-b37be7bc74d7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:46:53.766472	normal	normal	0.813	f	Demo Camera	0.212	0.813	low	1
79acbe03-e97f-47d0-a0b8-905746a95a74	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:46:57.151651	normal	normal	0.811	f	Demo Camera	0.339	0.811	low	1
bbc6eeae-101b-4855-9ef4-caf6b60f3d35	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:46:57.151739	normal	normal	0.811	f	Demo Camera	0.339	0.811	low	1
65b48f35-1440-4c65-9d9e-2f45122256cb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:47:00.672772	normal	normal	0.834	f	Demo Camera	0.182	0.834	low	1
458b1b4e-6a29-4a58-848d-c7daec2ea1bb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:47:00.672946	normal	normal	0.834	f	Demo Camera	0.182	0.834	low	1
7b55638d-a3a7-4432-907e-c6a7a3bccdf7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:47:27.805152	normal	weapon_detected	0.99	t	Demo Camera	0.406	0.99	high	1
08d09329-51d4-4051-b5f8-f4e1296d3320	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:47:27.805284	normal	weapon_detected	0.99	t	Demo Camera	0.406	0.99	high	1
839ae0da-3c39-4b5b-9fc0-f6d19e984f82	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:24.732231	normal	car_crash	0.99	t	Demo Camera	0.721	0.99	medium	1
1c4c6f96-1f3a-4092-9902-8ce94a9d926d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:24.732431	normal	car_crash	0.99	t	Demo Camera	0.721	0.99	medium	1
93e0b497-8b57-4e80-afe8-316b4e4115ae	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:27.977925	normal	car_crash	0.99	t	Demo Camera	0.297	0.99	medium	1
5e13f8b2-88d8-4587-92e8-0ac73dcd4601	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:27.978059	normal	car_crash	0.99	t	Demo Camera	0.297	0.99	medium	1
403caf57-9855-48f2-8ba7-cbe3d2b68e74	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:38.769146	normal	weapon_detected	0.99	t	Demo Camera	0.238	0.99	high	1
fcb535d5-b691-40c4-bfda-36bb1cf0b5b1	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:38.769307	normal	weapon_detected	0.99	t	Demo Camera	0.238	0.99	high	1
d178530f-cc1d-4a27-b2d8-2ca8ace913c6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:50.851739	normal	normal	0.807	f	Demo Camera	0.212	0.807	low	1
908ff5b3-f0c7-40d1-b819-ea600773e8dd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:50.851942	normal	normal	0.807	f	Demo Camera	0.212	0.807	low	1
cccb4a99-e61e-421b-a316-c32c97777746	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:54.153042	normal	normal	0.811	f	Demo Camera	0.339	0.811	low	1
14586759-c2d6-4fdb-abc3-d8193d73ac14	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:54.153248	normal	normal	0.811	f	Demo Camera	0.339	0.811	low	1
17153957-de83-4368-8bf8-078066c44c99	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:57.576753	normal	normal	0.741	f	Demo Camera	0.182	0.741	low	1
78e58631-03ad-46b5-a7c6-e77f79656118	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:57.576843	normal	normal	0.741	f	Demo Camera	0.182	0.741	low	1
54dc7434-9acd-4dfb-b97a-8e64b18516d6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:39.902422	normal	weapon_detected	0.99	t	Demo Camera	0.186	0.99	high	1
a0bddd1d-cebc-4097-a309-09b37cab8a1c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:39.902661	normal	weapon_detected	0.99	t	Demo Camera	0.186	0.99	high	1
f0ca43dc-8d55-4bac-b84a-e5188111c4e1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:41.50671	normal	weapon_detected	0.99	t	Demo Camera	0.196	0.99	high	1
bd748a17-a6f7-4ee9-a03d-15fb6b19d885	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:41.506862	normal	weapon_detected	0.99	t	Demo Camera	0.196	0.99	high	1
4a5565d6-9729-4fdc-b20f-3b4b44fa5d18	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:43.083886	normal	weapon_detected	0.99	t	Demo Camera	0.185	0.99	high	1
cc03748a-2c9d-4313-8a58-b184775604ca	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:43.084035	normal	weapon_detected	0.99	t	Demo Camera	0.185	0.99	high	1
93527417-459c-42ab-b964-d2bfd63e175f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:44.716388	normal	weapon_detected	0.983	t	Demo Camera	0.38	0.983	high	1
0e00bc95-6941-4390-a4d5-c48333920053	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:44.716593	normal	weapon_detected	0.983	t	Demo Camera	0.38	0.983	high	1
dc1dd2f4-ff08-496a-a79d-d792119716bd	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:46.305413	normal	weapon_detected	0.99	t	Demo Camera	0.283	0.99	high	1
8d44071e-0e25-4466-b4a9-4f0357639443	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:46.305562	normal	weapon_detected	0.99	t	Demo Camera	0.283	0.99	high	1
75620074-9f7a-4f69-9570-635535d946d5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:47.900824	normal	weapon_detected	0.87	t	Demo Camera	0.229	0.87	high	1
5fd822c6-4d26-429e-9857-9b00de24dc2d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:47.901017	normal	weapon_detected	0.87	t	Demo Camera	0.229	0.87	high	1
6063ac04-9ca5-4436-becb-47cdff7cb5ca	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:49.469639	normal	weapon_detected	0.99	t	Demo Camera	0.329	0.99	high	1
b5f16968-b527-40df-a48f-74215c122b34	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:49.469825	normal	weapon_detected	0.99	t	Demo Camera	0.329	0.99	high	1
5f7bf060-a6f6-4288-9e83-46ded8a36c67	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:51.037321	normal	weapon_detected	0.99	t	Demo Camera	0.353	0.99	high	1
fbc26976-3ead-476c-a317-9a377abbe5b9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:51.037541	normal	weapon_detected	0.99	t	Demo Camera	0.353	0.99	high	1
5425a41e-04f2-42d8-a60b-b483264f4b6f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:54.29689	normal	weapon_detected	0.952	t	Demo Camera	0.197	0.952	high	1
1efb409c-311a-4771-be5d-14c808fad5ed	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:54.297097	normal	weapon_detected	0.952	t	Demo Camera	0.197	0.952	high	1
ad582e1c-8949-4920-ae0a-fb431f6c8865	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:55.828807	normal	weapon_detected	0.759	t	Demo Camera	0.341	0.759	high	1
76bbaa89-4566-466a-b369-808fddac2b2b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:55.828978	normal	weapon_detected	0.759	t	Demo Camera	0.341	0.759	high	1
7d0824dc-3f2e-4cee-bc2c-e28c9323ff1a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:42:46.018865	normal	normal	0.837	f	Demo Camera	0.802	0.837	low	1
56bf45f0-00d4-4492-8630-283186515ffb	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:42:46.01913	normal	normal	0.837	f	Demo Camera	0.802	0.837	low	1
89822e87-f166-4566-ab54-728351f029c1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:46:54.66181	normal	normal	0.813	f	Demo Camera	0.187	0.806	low	1
83197942-06be-45e9-864d-f07287fc0d4b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:46:54.661915	normal	normal	0.813	f	Demo Camera	0.187	0.806	low	1
bfcf008e-4454-4b7f-9002-64ef1df03f84	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:47:01.494203	normal	normal	0.813	f	Demo Camera	0.431	0.813	low	1
b08d0f48-9ce0-4330-8cdb-bd860c250255	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:47:01.4943	normal	normal	0.813	f	Demo Camera	0.431	0.813	low	1
c14c0db8-feb4-455c-b468-e7bbc4ced598	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:47:26.268499	normal	weapon_detected	0.99	t	Demo Camera	0.183	0.99	high	1
9af3470c-8408-420c-a0ae-7e177e7ebebd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:47:26.268645	normal	weapon_detected	0.99	t	Demo Camera	0.183	0.99	high	1
13e7f2d7-6a11-483e-819f-683fb1d89812	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-19 19:47:28.262532	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.715	high	1
2968cc39-58c9-471d-bfae-961374e675d4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-19 19:47:28.262624	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.715	high	1
ec37911f-266e-42bc-a84d-9e8175f618a2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:22.371559	normal	car_crash	0.99	t	Demo Camera	0.441	0.99	medium	1
2c38ca85-2ada-41d9-a3cd-a85ae945391c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:22.371816	normal	car_crash	0.99	t	Demo Camera	0.441	0.99	medium	1
c6d8ae58-b4a9-4348-80d0-870d7395bf9f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:25.572626	normal	car_crash	0.99	t	Demo Camera	0.79	0.99	medium	1
1012439f-56ce-4066-8238-da20dd0e7304	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:25.572825	normal	car_crash	0.99	t	Demo Camera	0.79	0.99	medium	1
e6aacc54-2329-48d7-846f-01fe2249faef	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:39.227061	normal	weapon_detected	0.99	t	Demo Camera	0.641	0.99	high	1
ad3b596a-9abd-41e9-9038-8763fa50645e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:39.227178	normal	weapon_detected	0.99	t	Demo Camera	0.641	0.99	high	1
3a72336d-19d7-4811-a4d6-717e08980adb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:51.725337	normal	normal	0.813	f	Demo Camera	0.187	0.798	low	1
cad7d05e-30fc-4afd-9cd8-d9f48fd14d5c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:51.725479	normal	normal	0.813	f	Demo Camera	0.187	0.798	low	1
b6833ea2-2906-4863-9741-e9339ef1d166	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:55.055407	normal	weapon_detected	0.886	t	Demo Camera	0.339	0.886	high	1
33e76e31-0ff1-4c3d-b93a-7590d7f75c15	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:55.055515	normal	weapon_detected	0.886	t	Demo Camera	0.339	0.886	high	1
4a74991c-6eed-4d46-9b16-ab4d1ecfc8bb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:29:58.368728	normal	normal	0.745	f	Demo Camera	0.431	0.745	low	1
11366031-a766-480b-b5da-44d3a3ddc79e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:29:58.368922	normal	normal	0.745	f	Demo Camera	0.431	0.745	low	1
e11e34f6-b04d-4c1a-98db-285ff18ac5ab	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:38.693576	normal	weapon_detected	0.976	t	Demo Camera	0.233	0.976	high	1
14e12f96-618a-4da6-ae39-d3ae088a4e12	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:38.693756	normal	weapon_detected	0.976	t	Demo Camera	0.233	0.976	high	1
81746941-8a5a-4830-b8b0-df3013276279	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:40.317064	normal	weapon_detected	0.932	t	Demo Camera	0.443	0.932	high	1
d5655380-985d-4b7b-b629-71c9af1f71cf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:40.317251	normal	weapon_detected	0.932	t	Demo Camera	0.443	0.932	high	1
2f55cb45-1fdd-4515-980f-da1a0e72a32f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:41.894952	normal	weapon_detected	0.99	t	Demo Camera	0.215	0.99	high	1
bd1b73a4-a885-41c8-8cf4-13103dd4574d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:41.895155	normal	weapon_detected	0.99	t	Demo Camera	0.215	0.99	high	1
d45ea7e9-2d5c-4369-9e8b-dc1595d310a2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:43.497927	normal	weapon_detected	0.99	t	Demo Camera	0.181	0.99	high	1
b7e8ff38-a897-4af9-b111-54566880428b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:43.498123	normal	weapon_detected	0.99	t	Demo Camera	0.181	0.99	high	1
1466a6a9-6dab-4445-90c8-3d6031d50735	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:45.111716	normal	weapon_detected	0.99	t	Demo Camera	0.386	0.99	high	1
c68878eb-a04a-47a8-b06b-37711445637e	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:45.111867	normal	weapon_detected	0.99	t	Demo Camera	0.386	0.99	high	1
8e514722-aae7-4cec-91ea-90d09c4b32c9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:46.691477	normal	weapon_detected	0.99	t	Demo Camera	0.4	0.99	high	1
3bd8790a-15f3-435e-abb0-c8d918912076	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:46.691634	normal	weapon_detected	0.99	t	Demo Camera	0.4	0.99	high	1
d1ef1db3-ec6c-453a-bf70-c966c751a6ac	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:48.297959	normal	weapon_detected	0.99	t	Demo Camera	0.192	0.99	high	1
de43727c-7985-475d-8bfa-6f9704ce12bc	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:48.298171	normal	weapon_detected	0.99	t	Demo Camera	0.192	0.99	high	1
a314efb2-fbb0-4b5d-8399-a47e5bb12a21	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:49.860349	normal	weapon_detected	0.99	t	Demo Camera	0.692	0.99	high	1
2b1ace6f-c0c6-4549-97f3-8f96df9ff07c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:49.860566	normal	weapon_detected	0.99	t	Demo Camera	0.692	0.99	high	1
896d9bd7-0be2-4a5b-b177-16767856c07b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:51.427891	normal	weapon_detected	0.95	t	Demo Camera	0.462	0.95	high	1
ed66bf7c-0612-4463-8d6e-341eb5adcea7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:51.428031	normal	weapon_detected	0.95	t	Demo Camera	0.462	0.95	high	1
70b543f2-04c2-416c-891f-b21464e6f326	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:53.082975	normal	weapon_detected	0.875	t	Demo Camera	0.346	0.875	high	1
efc517df-389c-4fc4-87b4-89dd14a8ba0d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:53.083158	normal	weapon_detected	0.875	t	Demo Camera	0.346	0.875	high	1
519dec91-bc66-45e0-8538-caa8eba2f48c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:54.696466	normal	weapon_detected	0.882	t	Demo Camera	0.267	0.882	high	1
366571a8-b3e6-4df6-ad4c-e89f1973c4f3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:54.696681	normal	weapon_detected	0.882	t	Demo Camera	0.267	0.882	high	1
7f5166f2-b06f-4036-a4e2-949906c05b4b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:30:56.214041	normal	weapon_detected	0.99	t	Demo Camera	0.762	0.99	high	1
277e0e5a-e793-4ebd-b600-f4a7582ad123	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:30:56.214191	normal	weapon_detected	0.99	t	Demo Camera	0.762	0.99	high	1
a78a0dc2-8f64-4123-89b8-619dda55493f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:41.700829	normal	explosion	0.679	t	Demo Camera	0.227	0.679	high	1
7e98283f-11fd-4a84-81d1-c2305aa9e327	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:41.701047	normal	explosion	0.679	t	Demo Camera	0.227	0.679	high	1
10ab75b1-d504-4c9e-b8ab-10f01c86eca9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:42.303559	normal	normal	0.458	f	Demo Camera	0.339	0.542	low	1
c7535fa6-f7ce-425c-9df3-abf7a1ffea83	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:42.303684	normal	normal	0.458	f	Demo Camera	0.339	0.542	low	1
22b9f77a-c2fb-4d45-bee4-aa86a78cef23	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:45.050123	normal	explosion	0.739	t	Demo Camera	0.182	0.739	high	1
f189a872-54d7-4b2b-8283-9c80ed5f7e0d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:45.05021	normal	explosion	0.739	t	Demo Camera	0.182	0.739	high	1
6da58001-a22b-4d95-9830-6675c1e3890f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:45.664347	normal	explosion	0.728	t	Demo Camera	0.431	0.728	high	1
59d23be5-91f8-426c-bd93-f0f9f40c41de	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:45.664504	normal	explosion	0.728	t	Demo Camera	0.431	0.728	high	1
e8df36c2-c49c-418c-8a9f-0c8833763093	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:46.317115	normal	explosion	0.846	t	Demo Camera	0.513	0.676	high	1
3144762b-0d31-4f8e-b2ce-17acba79c36b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:46.317219	normal	explosion	0.846	t	Demo Camera	0.513	0.676	high	1
026728c2-5db6-4be5-b717-6b30d450b742	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:47.417356	normal	explosion	0.551	t	Demo Camera	0.212	0.551	high	1
36fa1453-3f0f-4d33-8438-9a2b33cbf3c2	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:47.417523	normal	explosion	0.551	t	Demo Camera	0.212	0.551	high	1
83f20843-1f0c-4e21-8356-8d7a0130835f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:48.11558	normal	explosion	0.813	t	Demo Camera	0.187	0.577	high	1
940afdd4-f40c-4566-ba22-9666e71a5a9c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:48.115833	normal	explosion	0.813	t	Demo Camera	0.187	0.577	high	1
45a7e0db-d072-4545-9e18-8bffeb110a3a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:49.376439	normal	explosion	0.679	t	Demo Camera	0.227	0.679	high	1
f0cbc8cc-391e-4f2c-b0d9-c531b72fc2ff	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:49.376645	normal	explosion	0.679	t	Demo Camera	0.227	0.679	high	1
737037ee-f2fb-4bf4-a9b3-f1be6c6b7630	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:49.982544	normal	normal	0.458	f	Demo Camera	0.339	0.542	low	1
0c3b1796-c542-44f7-b170-408748a57162	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:49.982745	normal	normal	0.458	f	Demo Camera	0.339	0.542	low	1
3df4d507-3b3f-41b5-8ec5-a84827aac8e6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:51.367817	normal	explosion	0.577	t	Demo Camera	0.343	0.577	high	1
94169241-49c7-4d14-ae1c-0d755f5b9233	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:51.367967	normal	explosion	0.577	t	Demo Camera	0.343	0.577	high	1
36646599-0f2d-4423-a814-44feceb9816b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:51.989728	normal	explosion	0.678	t	Demo Camera	0.286	0.678	high	1
7a5a3992-6dd4-4c99-a9ad-c68f4eed05fe	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:51.989822	normal	explosion	0.678	t	Demo Camera	0.286	0.678	high	1
7f791536-3826-4113-ad2d-d70b6645b65b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:52.68534	normal	explosion	0.739	t	Demo Camera	0.182	0.739	high	1
5e32912c-65d7-4354-82d7-4144374141c9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:52.685501	normal	explosion	0.739	t	Demo Camera	0.182	0.739	high	1
3e2f8561-9ba6-44b7-8d45-ad018206b180	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:53.325006	normal	explosion	0.728	t	Demo Camera	0.431	0.728	high	1
15661b2a-a205-4a11-b34d-ad8eaec96d35	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:53.325135	normal	explosion	0.728	t	Demo Camera	0.431	0.728	high	1
96763399-6385-4614-ab2d-1b3edc601d14	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:35:53.972575	normal	explosion	0.846	t	Demo Camera	0.513	0.676	high	1
1f3de82b-2aa5-4eb6-815d-652b7711f6bd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:35:53.972668	normal	explosion	0.846	t	Demo Camera	0.513	0.676	high	1
add0048a-6903-45d6-8630-1a4ae4bec45f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:36:08.862218	normal	weapon_detected	0.892	t	Demo Camera	0.183	0.892	high	1
aac02329-1bd0-48e4-8598-710a2c99d31b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:36:08.862407	normal	weapon_detected	0.892	t	Demo Camera	0.183	0.892	high	1
8eed1ab3-84de-4270-9c24-6e39aed25d7b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:36:09.179311	normal	weapon_detected	0.902	t	Demo Camera	0.238	0.902	high	1
08db9c0a-c1fc-4a3f-b565-2e30527965b4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:36:09.179416	normal	weapon_detected	0.902	t	Demo Camera	0.238	0.902	high	1
fe15fa51-5557-4b91-a433-dfb17b7ec313	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:36:09.455181	normal	weapon_detected	0.855	t	Demo Camera	0.641	0.855	high	1
755995c6-bfbc-4e5a-847d-49671ce1ba5a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:36:09.455268	normal	weapon_detected	0.855	t	Demo Camera	0.641	0.855	high	1
ddc7a386-9f59-49e2-8538-72a81c8bc27d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:36:09.81197	normal	weapon_detected	0.94	t	Demo Camera	0.406	0.94	high	1
b8a5244d-d361-412d-a6e5-77f94a1d3bdf	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:36:09.812113	normal	weapon_detected	0.94	t	Demo Camera	0.406	0.94	high	1
f7f7bf9a-2f4a-4049-9636-0e290b6cd5d5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:36:10.153787	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.562	high	1
b5a21636-24bd-4fd4-9130-8b6e5e595f67	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:36:10.153868	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.562	high	1
dd953f20-d8c0-4c14-bf47-b3623a56ade2	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:16.158725	normal	explosion	0.679	t	Demo Camera	0.227	0.679	high	1
582e71f7-10f5-481f-81c3-416a45f47992	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:16.158843	normal	explosion	0.679	t	Demo Camera	0.227	0.679	high	1
53870109-695f-4933-a330-d45c97f416a7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:18.787018	normal	explosion	0.678	t	Demo Camera	0.286	0.678	high	1
f25173cf-717f-4390-8aa6-9edac0578df7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:18.78716	normal	explosion	0.678	t	Demo Camera	0.286	0.678	high	1
854f28be-6234-4439-87a9-06c8aa213903	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:24.743281	normal	weapon_detected	0.902	t	Demo Camera	0.238	0.902	high	1
055d9415-c357-4943-bd4b-afad2f741695	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:24.743382	normal	weapon_detected	0.902	t	Demo Camera	0.238	0.902	high	1
98204903-e63f-4876-81e5-f5258bd0bef0	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:30.020039	normal	car_crash	0.952	t	Demo Camera	0.75	0.952	medium	1
adf30a6a-ae20-4f18-961f-0ca64a2aa387	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:30.020233	normal	car_crash	0.952	t	Demo Camera	0.75	0.952	medium	1
56029ce9-4e2f-4241-993e-f70292497e2e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:34.498461	normal	weapon_detected	0.892	t	Demo Camera	0.183	0.892	high	1
4b07edb9-fac6-48c3-92f4-35f163e787e8	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:34.49854	normal	weapon_detected	0.892	t	Demo Camera	0.183	0.892	high	1
e431308a-b105-4fd8-9113-6d2d7783d6cc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:35.546299	normal	weapon_detected	0.94	t	Demo Camera	0.406	0.94	high	1
fc1708a9-fca3-4524-813d-e2bd2e13ab55	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:35.546381	normal	weapon_detected	0.94	t	Demo Camera	0.406	0.94	high	1
d24768b3-1f07-46ca-a460-c3900c0f7d2f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:37.500618	normal	car_crash	0.905	t	Demo Camera	0.441	0.905	medium	1
397791f5-b529-4751-af6d-650a25e6cbf7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:37.500772	normal	car_crash	0.905	t	Demo Camera	0.441	0.905	medium	1
02d1c9e2-8d5b-408e-bc8d-8daca80646f5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:39.962973	normal	car_crash	0.956	t	Demo Camera	0.79	0.956	medium	1
5947fc64-9332-4cde-96e9-21fe46e90bb6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:39.963152	normal	car_crash	0.956	t	Demo Camera	0.79	0.956	medium	1
3a8b028b-7d30-476e-84ef-3fb0d4ec07fb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:38:02.710166	normal	normal	0.458	f	Demo Camera	0.339	0.542	low	1
39c4923c-aca5-49d9-868b-30b5111f2c29	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:38:02.710317	normal	normal	0.458	f	Demo Camera	0.339	0.542	low	1
e6e3f1e8-1100-4c7f-8ef4-e2b0762df37c	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:38:05.411145	normal	explosion	0.739	t	Demo Camera	0.182	0.739	high	1
d1c3fd23-9337-485c-8f59-49b7954366fe	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:38:05.411337	normal	explosion	0.739	t	Demo Camera	0.182	0.739	high	1
ebb2b777-7c7a-422a-b47d-c8c56a7bdf19	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:16.783526	normal	normal	0.458	f	Demo Camera	0.339	0.542	low	1
d456633a-9f1d-4c8e-901c-10f99a1a926a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:16.783668	normal	normal	0.458	f	Demo Camera	0.339	0.542	low	1
6bbe4aef-0e33-4c11-9d71-8e67e81b273f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:19.48061	normal	explosion	0.739	t	Demo Camera	0.182	0.739	high	1
85da3747-1426-443d-97b4-c7fa4fb68296	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:19.480862	normal	explosion	0.739	t	Demo Camera	0.182	0.739	high	1
23b1d0b3-69bc-4ffa-af42-3c1866b324ee	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:25.843525	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.562	high	1
1d10f6b9-bfd8-437d-8c00-90c2bbd3440c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:25.843673	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.562	high	1
adc0184e-0b6d-4444-b9cd-d0319ac6d5df	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:28.154381	normal	car_crash	0.956	t	Demo Camera	0.721	0.956	medium	1
178bf202-f525-4f14-b847-074bacb3eab6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:28.154507	normal	car_crash	0.956	t	Demo Camera	0.721	0.956	medium	1
06041c1d-7ca8-4c58-b510-725847913024	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:30.703687	normal	car_crash	0.95	t	Demo Camera	0.297	0.95	medium	1
b7d1d841-a904-4b9a-a495-927f3462ceb4	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:30.703824	normal	car_crash	0.95	t	Demo Camera	0.297	0.95	medium	1
b87bbaf5-d3c3-450d-8994-beba5943b23d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:34.824675	normal	weapon_detected	0.902	t	Demo Camera	0.238	0.902	high	1
f227156c-afce-4563-a4f1-56eb62fc8225	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:34.82476	normal	weapon_detected	0.902	t	Demo Camera	0.238	0.902	high	1
3c4f7c6c-4117-4ac4-a19b-7cc49547e22b	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:35.952156	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.562	high	1
83a0928a-bf5b-4d16-be1c-cffc6d937981	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:35.952247	normal	weapon_detected	0.861	t	Demo Camera	0.465	0.562	high	1
f9716052-8dd7-42e1-8417-c0021f5935d7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:38.068198	normal	car_crash	0.938	t	Demo Camera	0.771	0.938	medium	1
dad83ce3-adba-4a46-808f-9c4eb123bc77	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:38.068301	normal	car_crash	0.938	t	Demo Camera	0.771	0.938	medium	1
007a9345-3419-40cb-88ab-2069b49f259a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:40.53187	normal	car_crash	0.955	t	Demo Camera	0.802	0.955	medium	1
295c3c76-c79c-4763-8ed7-843c6c34f979	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:40.53198	normal	car_crash	0.955	t	Demo Camera	0.802	0.955	medium	1
1ec6c21e-577e-46f9-a036-23fddea4e0a1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:38:06.027799	normal	explosion	0.728	t	Demo Camera	0.431	0.728	high	1
36fce813-2b29-4652-a795-00540428614c	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:38:06.027976	normal	explosion	0.728	t	Demo Camera	0.431	0.728	high	1
0172bf60-3e31-4524-85b7-22a322fe0043	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:18.165206	normal	normal	0.574	f	Demo Camera	0.343	0.574	low	1
f622565a-cb60-49f8-932a-ae516707a9ee	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:18.165301	normal	normal	0.574	f	Demo Camera	0.343	0.574	low	1
ac8c997e-e420-4c96-8564-b25b95f29777	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:20.746668	normal	explosion	0.846	t	Demo Camera	0.513	0.676	high	1
09ef9c1d-7ec2-4491-95b0-dcf4c96e4474	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:20.746891	normal	explosion	0.846	t	Demo Camera	0.513	0.676	high	1
96a33b85-5b2d-4d80-8700-49b2cd5cad3a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:24.370181	normal	weapon_detected	0.892	t	Demo Camera	0.183	0.892	high	1
99c3d504-ea09-4d5f-b29d-18c155cfd417	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:24.370275	normal	weapon_detected	0.892	t	Demo Camera	0.183	0.892	high	1
60901016-1dcc-48d8-b7d8-b2ba6519a48e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:25.468071	normal	weapon_detected	0.94	t	Demo Camera	0.406	0.94	high	1
804118eb-3f4c-4d7f-8998-abe1f4d311b3	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:25.468226	normal	weapon_detected	0.94	t	Demo Camera	0.406	0.94	high	1
acedaa25-64e0-434c-a654-03b17ea0a29d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:26.881964	normal	car_crash	0.938	t	Demo Camera	0.771	0.938	medium	1
6dba04f5-8196-4cbb-b2a5-fc89874853b7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:26.882142	normal	car_crash	0.938	t	Demo Camera	0.771	0.938	medium	1
54939ec9-fead-4024-8e0c-4c2485bcb581	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:29.366761	normal	car_crash	0.955	t	Demo Camera	0.802	0.955	medium	1
39e384fa-81d0-4950-b3a8-686b325e0a5a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:29.366848	normal	car_crash	0.955	t	Demo Camera	0.802	0.955	medium	1
586b65bf-3a3e-4f4c-854e-8207696239c4	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:39.308993	normal	car_crash	0.956	t	Demo Camera	0.721	0.956	medium	1
761251be-2631-4d46-a76c-7535d4f1bcc7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:39.309144	normal	car_crash	0.956	t	Demo Camera	0.721	0.956	medium	1
afdb019e-85e8-471f-8a27-2ac9c998a678	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:41.879882	normal	car_crash	0.95	t	Demo Camera	0.297	0.95	medium	1
d00835aa-a4da-4660-8e9e-10654b398752	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:41.879985	normal	car_crash	0.95	t	Demo Camera	0.297	0.95	medium	1
cdcd461c-f6cf-4993-8ff5-01093d03cb57	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:38:02.101629	normal	explosion	0.679	t	Demo Camera	0.227	0.679	high	1
b8d93e08-dd5d-40ea-a337-59389ecb07d9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:38:02.101736	normal	explosion	0.679	t	Demo Camera	0.227	0.679	high	1
a1ad06bf-5a17-4178-8359-64d57276a232	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:38:04.716049	normal	explosion	0.678	t	Demo Camera	0.286	0.678	high	1
5d74bfa4-320c-40d5-a714-b48549886ca7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:38:04.716199	normal	explosion	0.678	t	Demo Camera	0.286	0.678	high	1
98322302-33ec-43f2-8011-6d1edb4118c9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:20.096453	normal	explosion	0.728	t	Demo Camera	0.431	0.728	high	1
b70d46b5-5e42-45f3-897d-e5e852e1b9b7	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:20.096634	normal	explosion	0.728	t	Demo Camera	0.431	0.728	high	1
67a6e721-c9a7-4457-a429-8a486e0b0c84	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:25.06297	normal	weapon_detected	0.855	t	Demo Camera	0.641	0.855	high	1
f7e352ad-7151-4819-aa1c-3b14eb2feb21	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:25.063127	normal	weapon_detected	0.855	t	Demo Camera	0.641	0.855	high	1
104c58eb-b6c2-4c85-8af4-402ea25cafa1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:26.31264	normal	car_crash	0.905	t	Demo Camera	0.441	0.905	medium	1
2ca1fe67-74ee-471f-b7eb-6e116ce30762	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:26.31273	normal	car_crash	0.905	t	Demo Camera	0.441	0.905	medium	1
de7192f8-89bb-433a-b34c-5d49c719f7d5	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:28.806278	normal	car_crash	0.956	t	Demo Camera	0.79	0.956	medium	1
caf7701b-3cba-4b0d-9df6-8de856fb5d01	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:28.806462	normal	car_crash	0.956	t	Demo Camera	0.79	0.956	medium	1
b4f0f389-081a-4b9f-ae6f-7b006050e643	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:35.13221	normal	weapon_detected	0.855	t	Demo Camera	0.641	0.855	high	1
12b60e81-d4d9-4de1-b800-faca7e0ab146	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:35.132302	normal	weapon_detected	0.855	t	Demo Camera	0.641	0.855	high	1
ec43beaa-2587-4c00-a319-ca29b0258382	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:37:41.210216	normal	car_crash	0.952	t	Demo Camera	0.75	0.952	medium	1
3a862734-7a85-46cb-8e10-efb78d748666	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:37:41.21032	normal	car_crash	0.952	t	Demo Camera	0.75	0.952	medium	1
1e842e5f-4356-4497-8015-eb368c24edb6	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:38:04.071611	normal	normal	0.574	f	Demo Camera	0.343	0.574	low	1
148fa19a-02e2-4455-a9b9-b59cc4ef0d3a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:38:04.071709	normal	normal	0.574	f	Demo Camera	0.343	0.574	low	1
26b5fd10-59d9-4a9f-83a8-f60ec0ac1d7e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-05-20 06:38:06.672725	normal	explosion	0.846	t	Demo Camera	0.513	0.676	high	1
18527704-b44b-47c7-af2f-9f81bea82c92	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-05-20 06:38:06.672903	normal	explosion	0.846	t	Demo Camera	0.513	0.676	high	1
ad6db314-d2f3-46ed-bd46-9f53fc76c59d	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:26:59.758293	normal	violence	0.545	t	Demo Camera	0.239	0.545	high	1
131fac88-e03f-42e7-8ada-aa2c2dcd2050	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:26:59.758456	normal	violence	0.545	t	Demo Camera	0.239	0.545	high	1
7eb9cdea-8435-4172-897c-8269b469ac68	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:00.550319	normal	normal	0.694	f	Demo Camera	0.306	0.356	low	1
9a6b4a4c-a199-4aa3-aff4-bdc4454afc3a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:00.550365	normal	normal	0.694	f	Demo Camera	0.306	0.356	low	1
7a4f7c89-949b-4e60-9b54-70d90b0d1329	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:01.123428	impact	car_crash	0.51	t	Demo Camera	0.391	0.48	high	1
c0df63fb-0ad9-4423-8ccd-9e6760fd7df6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:01.123524	impact	car_crash	0.51	t	Demo Camera	0.391	0.48	high	1
7c690102-b189-4fd4-9a1e-8cb2992953b7	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:01.823104	normal	violence	0.883	t	Demo Camera	0.229	0.883	high	1
a28fa123-8c65-4062-bf6c-93da0084b5e5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:01.823146	normal	violence	0.883	t	Demo Camera	0.229	0.883	high	1
533fc3d0-7149-4669-90ea-fe9457ceefcc	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:02.437589	normal	violence	0.894	t	Demo Camera	0.644	0.894	high	1
d3d0f9a4-2af1-4757-97fe-f948dd2f672f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:02.437626	normal	violence	0.894	t	Demo Camera	0.644	0.894	high	1
f0fd626c-79ba-46ac-bb6a-76a0ede9ed05	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:03.089626	normal	violence	0.879	t	Demo Camera	0.254	0.879	high	1
f87547c0-599c-4763-b429-c8c81fb9d9e5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:03.089662	normal	violence	0.879	t	Demo Camera	0.254	0.879	high	1
c76532e6-75a4-48b5-9110-84ed88027eeb	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:03.663295	normal	violence	0.883	t	Demo Camera	0.776	0.883	high	1
48ef22cc-c05c-447b-b653-f9e9bdf24e0f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:03.663329	normal	violence	0.883	t	Demo Camera	0.776	0.883	high	1
f22d76a1-e321-46d8-b671-c050445d1d1e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:04.282221	normal	violence	0.865	t	Demo Camera	0.45	0.83	high	1
f4b56951-c552-4e28-98d3-2122c3559365	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:04.282259	normal	violence	0.865	t	Demo Camera	0.45	0.83	high	1
36f4cc5e-c3e1-4563-ac89-49fb4eded00a	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:04.843143	normal	violence	0.83	t	Demo Camera	0.253	0.83	high	1
94487890-5e46-4ffd-8a1b-b8ac5eb3cf7a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:04.843181	normal	violence	0.83	t	Demo Camera	0.253	0.83	high	1
3c1801d8-0a69-45c2-850d-9847c2e3da00	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:05.48081	normal	violence	0.912	t	Demo Camera	0.778	0.912	high	1
8c941009-c94b-4dc7-93f1-bbbd68fab697	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:05.480846	normal	violence	0.912	t	Demo Camera	0.778	0.912	high	1
a7069569-a522-4cad-879c-1966894f2728	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:06.069126	normal	violence	0.912	t	Demo Camera	0.818	0.912	high	1
ea008919-7ed3-4113-ba2f-c25207dfc56b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:06.069161	normal	violence	0.912	t	Demo Camera	0.818	0.912	high	1
87f8c499-e9bf-45d3-9c6e-78b674706021	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:06.70751	normal	weapon_detected	0.749	t	Demo Camera	0.251	0.691	high	1
31e539f7-06c6-415a-9803-fecaf11caabd	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:06.707583	normal	weapon_detected	0.749	t	Demo Camera	0.251	0.691	high	1
cf41448c-2e55-48a2-addf-11edd20943ef	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:07.286112	normal	violence	0.907	t	Demo Camera	0.522	0.907	high	1
695ae61a-8cd1-4aa7-8d05-551ab5af580d	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:07.286148	normal	violence	0.907	t	Demo Camera	0.522	0.907	high	1
30396489-c5c4-4202-b501-f55de9746844	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-10 17:27:07.698546	normal	normal	0.716	f	Demo Camera	0.284	0.181	low	1
a0c21c54-0e17-434e-af9c-78a1e867d2a0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-10 17:27:07.698588	normal	normal	0.716	f	Demo Camera	0.284	0.181	low	1
01b353b0-af60-48c4-8642-17e6dc37195f	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:10.499004	normal	violence	0.545	t	Demo Camera	0.239	0.545	high	1
6a8f20c6-1699-4733-8262-841fdd87ec8b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:10.499106	normal	violence	0.545	t	Demo Camera	0.239	0.545	high	1
bf036f96-ce74-433c-b1eb-0718387587da	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:11.142501	normal	normal	0.694	f	Demo Camera	0.306	0.356	low	1
42b6a0fc-a4f8-4c46-b81a-ddc74bf94902	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:11.142543	normal	normal	0.694	f	Demo Camera	0.306	0.356	low	1
bf24d275-a80f-426c-a2cb-08055bce9207	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:11.718957	impact	car_crash	0.51	t	Demo Camera	0.391	0.48	high	1
a5431c94-1a2c-4377-b183-cf34798c794b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:11.719055	impact	car_crash	0.51	t	Demo Camera	0.391	0.48	high	1
696065cf-49b2-42d7-ac9f-41f3597efab8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:12.370604	normal	violence	0.883	t	Demo Camera	0.229	0.883	high	1
f7fca2fb-9724-4c98-8d8a-36e2325def37	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:12.370641	normal	violence	0.883	t	Demo Camera	0.229	0.883	high	1
b27fd6df-f843-40bb-84d0-2a335736ec14	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:12.962398	normal	violence	0.894	t	Demo Camera	0.644	0.894	high	1
e623a3b9-d433-493d-a407-0fb245c558d0	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:12.962433	normal	violence	0.894	t	Demo Camera	0.644	0.894	high	1
35aef046-f778-4cdb-9462-b0ba0b8a5794	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:13.60967	normal	violence	0.879	t	Demo Camera	0.254	0.879	high	1
58c9d3fa-cf4d-4fb4-b8eb-a7f4788067f6	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:13.609707	normal	violence	0.879	t	Demo Camera	0.254	0.879	high	1
0465d45c-b13a-45c6-9c71-6bf94951adb9	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:14.195237	normal	violence	0.883	t	Demo Camera	0.776	0.883	high	1
2339f78e-03b8-4f4f-95f4-505e65b83965	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:14.195273	normal	violence	0.883	t	Demo Camera	0.776	0.883	high	1
b4f708fb-1f59-46b6-baa2-32df558b9b94	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:14.816469	normal	violence	0.865	t	Demo Camera	0.45	0.83	high	1
f0b92b4f-ca45-4017-86b7-2f45f0214c48	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:14.816509	normal	violence	0.865	t	Demo Camera	0.45	0.83	high	1
a6486ccc-d378-475d-bf37-e35c3229e8e1	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:15.373116	normal	violence	0.83	t	Demo Camera	0.253	0.83	high	1
6284cef8-7c29-4960-a35b-8a47b0a341c9	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:15.373153	normal	violence	0.83	t	Demo Camera	0.253	0.83	high	1
78fb39b1-4faa-467c-b01b-7381cda84e9e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:16.003233	normal	violence	0.912	t	Demo Camera	0.778	0.912	high	1
e07828e4-b4d1-47ed-bfe4-791a3ad2d45b	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:16.003269	normal	violence	0.912	t	Demo Camera	0.778	0.912	high	1
d07b1eb3-e124-4e9e-8ce9-e346c103b86e	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:16.599781	normal	violence	0.912	t	Demo Camera	0.818	0.912	high	1
9948c4c0-3f66-4163-8014-4404d88874f5	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:16.59982	normal	violence	0.912	t	Demo Camera	0.818	0.912	high	1
f97a8fac-31e4-4d6b-95c0-e8c0eb553fca	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:17.268206	normal	weapon_detected	0.749	t	Demo Camera	0.251	0.691	high	1
110ccf4d-f545-4b6b-a7fb-17da86530e4f	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:17.268274	normal	weapon_detected	0.749	t	Demo Camera	0.251	0.691	high	1
3273ee6e-fa54-4591-a161-73924e681754	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:17.839073	normal	violence	0.907	t	Demo Camera	0.522	0.907	high	1
db1e8246-cefa-4562-86f5-2f08b5e66d53	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:17.83911	normal	violence	0.907	t	Demo Camera	0.522	0.907	high	1
4299e7d4-687d-4d51-a725-2b6bbe73c9d8	75bf04f9-2289-4776-a70a-e8d846c238fb	2026-06-11 21:59:18.24294	normal	normal	0.716	f	Demo Camera	0.284	0.181	low	1
f91821d2-1738-4697-b415-77b240728d6a	a1337918-24cf-4f3f-a1ee-20ef779692d6	2026-06-11 21:59:18.242974	normal	normal	0.716	f	Demo Camera	0.284	0.181	low	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, email, password_hash, created_at) FROM stdin;
75bf04f9-2289-4776-a70a-e8d846c238fb	Test User	test@example.com	$2b$12$UOoB/d6RCCXluQeOLHJov.de1WpLgZGBZnYRkFwsPc8Vmo4L4dlHu	2026-04-01 12:21:57.791414
a1337918-24cf-4f3f-a1ee-20ef779692d6	derya	derya@gmail.com	$2b$12$ff3DogoV9ure.hfAQ.hXVOqkCFVUbxlpj5RLaKUIvYmbY/A.Gls/6	2026-04-01 12:25:37.275511
\.


--
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict OipRh33z5CjMH3HaBO3cxB3VpymJj7kbcOCzeV5D1znnOifIzuOqAf3kcuyp3kk

