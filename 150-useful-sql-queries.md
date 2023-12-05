# Useful SQL Queries

<!--ts-->
* [Useful SQL Queries](./150-useful-sql-queries.md#useful-sql-queries)
   * [Selecting 1000 Messages](./150-useful-sql-queries.md#selecting-1000-messages)
   * [Joining Messages and Group Info](./150-useful-sql-queries.md#joining-messages-and-group-info)
   * [Filtering Messages by Keywords in Second Table](./150-useful-sql-queries.md#filtering-messages-by-keywords-in-second-table)
   * [Extract URLs from messages](./150-useful-sql-queries.md#extract-urls-from-messages)
   * [More interesting message](./150-useful-sql-queries.md#more-interesting-message)
   * [Groups contributed by user](./150-useful-sql-queries.md#groups-contributed-by-user)

<!-- Created by https://github.com/ekalinin/github-markdown-toc -->
<!-- Added by: runner, at: Tue Dec  5 10:35:43 UTC 2023 -->

<!--te-->


## Selecting 1000 Messages

```sql
SELECT * FROM `whatup-395208.messages.messages` LIMIT 1000
```

## Joining Messages and Group Info

```sql
SELECT
    m.*,
    gi.*
FROM `whatup-395208.messages.messages` AS m
LEFT JOIN `whatup-395208.messages.group_info` AS gi
    ON m.chat_jid = gi.id
LIMIT 1000
```


## Filtering Messages by Keywords in Second Table

This query will use the "fear-speech-emoji" static data table as a set of keywords and return messages that contain at least one keyword.

```sql
SELECT
  fear_emoji.*,
  message.*
FROM `whatup-395208.messages.messages` AS message
JOIN `whatup-395208.static_data.fear-speech-emoji` AS fear_emoji
ON message.text LIKE CONCAT('%', fear_emoji.emoji, '%') 
LIMIT 10
```

## Extract URLs from messages

This query will extract URLs from text in the messages table

```sql
SELEC
    link,
    REGEXP_EXTRACT_ALL(text, r"(http[^\s]+)") AS extracted_links
FROM
    `whatup-395208.messages.messages`
```

## More interesting message

As of Oct 25, 2023, the following query will show data from less-spammy sources. In the future, this may not be true and may actually reduce the number of non-spam messages you see.

```sql
SELECT *
FROM `whatup-395208.messages.messages` 
WHERE
  reciever_jid = "anon.8XQhD3Ge7Pw_z27v1xOYZ0-94dOUHbejSW_8w3Bud-Y.v001@s.whatsapp.net"
```

## Groups contributed by user

The following is a postgres query that can be adapted for bigquery.

```sql
select distinct
	gi."groupName_name" 
from messages as m
join group_info gi 
	on m.chat_jid = gi."JID" 
inner join registered_users ru 
	on (m.reciever_jid = ru.jid_anon or m.sender_jid = ru.jid_anon)
where 
	ru.username = 'MP12-a'
```
