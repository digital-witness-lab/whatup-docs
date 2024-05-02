# Creating a public view for data

> CAUTION: public views are *PUBLIC* and you should ensure that the data being made public is OK for release

<!--ts-->
## Table of Contents

- [Creating a public view for data](#creating-a-public-view-for-data)
  - [The process](#the-process)
    - [Using the UI](#using-the-ui)
    - [In the infrastructure](#in-the-infrastructure)
<!--te-->

## The process

Data needs to be made public for serveral possible reasons:

- To power a vis on our website
- To power a vis on a partner website
- To share in an ongoing manner with another organization

We accomplish this by having scheduled queries which copy a view of our data into the `whatup-prod.public` dataset. Note that if you want specifically to share this with a group of people who aren't public, speak to Micha about creating another dataset with limited permissions.


### Using the UI

note: this method works for our current setup, but the query may be lost if we need to migrate our infrastructure. Generally this is a good first step and then Micha should be notified so she can make the changes more permenant.

1. Create a SQL query which accomplishes the transformations you need
   - This should filter you data, redact if possible and generally get the data into a publicly presentable format
2. Click the hamburger menu in the query editor and select schedule ![image](https://github.com/digital-witness-lab/whatup-docs/assets/47370/85a863e4-7669-4f07-af2c-4702d9dc8fb7)
3. Name the query and select the update frequency (NOTE: be conservative with this and don't have the query run too often. Once a day should be a nice default to select)
4. Set a destination table for the query results and select the `public` dataset and name the table you'd like the results to go into ![image](https://github.com/digital-witness-lab/whatup-docs/assets/47370/babc589d-306a-459d-9267-0fb8715516f7)
5. Optional: If you are storing things like messages or any data with a timestamp associated with it, it is useful to set the partition field as that timestamp
6. Choose between OVERWITE and APPEND. Unless you specifically wrote your query to be an append-like query, you probably want to select OVERWRITE.
7. Save!

Your new query should run right away and then continue at the scheduled interval and your data should be availible in the `public` dataset. This dataset has open access and should be visible by the world.


### In the infrastructure

note: this method is harder to do, but it allows for more optimized queries and resiliency throughout infrastructure migrations. It will also be copied to any of our partner deployments so they will also get the capabilities of the queries defined here (unless we explicitly don't give them access)

1. Write the query and test it using the bigquery editor
2. Encode this query into a new "scheduled_task", following the [cloudsql_bigquery_transfer](https://github.com/digital-witness-lab/whatup/blob/04df540dde76a74435002608208870ba22f5a87d/infrastructure/scheduled_tasks/cloudsql_bigquery_transfer.py) example or the [translate_bigquery](https://github.com/digital-witness-lab/whatup/blob/04df540dde76a74435002608208870ba22f5a87d/infrastructure/scheduled_tasks/translate_bigquery.py) example.
3. Deploy pulumi.
