# WHATUP DOCUMENTATION

<!--ts-->
- [WhatUp Technical Docs](#whatup-technical-docs)
  - [What this doc is and what it isn't](#what-this-doc-is-and-what-it-isnt)
  - [Repo Contents](#repo-contents)
    - [Architecture Philosophy](#architecture-philosophy)
    - [File tree overview](#file-tree-overview)
    - [How Services Connect](#how-services-connect)
  - [Setup](#setup)
    - [Local Development Environment](#local-development-environment)
      - [Decrypting](#decrypting)
      - [Core Services](#core-services)
      - [On-Boarding a device](#on-boarding-a-device)
      - [Launching Bots](#launching-bots)
      - [Celebrate 🎊](#celebrate-)
- [Accessing WhatUp Data](#accessing-whatup-data)
  - [Ways to see WhatUp Data](#ways-to-see-whatup-data)
  - [Ways to access data](#ways-to-access-data)
    - [WebUI with BigQuery](#webui-with-bigquery)
    - [WebUI with Colab](#webui-with-colab)
    - [WebUI with Looker or Sheets](#webui-with-looker-or-sheets)
      - [Method 1](#method-1)
      - [Method 2](#method-2)
      - [Method 3 (only Sheets)](#method-3-only-sheets)
    - [Python](#python)
  - [Ways of accessing third party data in BigQuery](#ways-of-accessing-third-party-data-in-bigquery)
    - [Sheets Source](#sheets-source)
- [Creating a public view for data](#creating-a-public-view-for-data)
  - [The process](#the-process)
    - [Using the UI](#using-the-ui)
    - [In the infrastructure](#in-the-infrastructure)
- [Useful SQL Queries](#useful-sql-queries)
  - [Selecting 1000 Messages](#selecting-1000-messages)
  - [Joining Messages and Group Info](#joining-messages-and-group-info)
  - [Filtering Messages by Keywords in Second Table](#filtering-messages-by-keywords-in-second-table)
  - [Extract URLs from messages](#extract-urls-from-messages)
  - [More interesting message](#more-interesting-message)
  - [Groups contributed by user](#groups-contributed-by-user)
- [Building Colab Notebooks](#building-colab-notebooks)
  - [Why Google Colab](#why-google-colab)
  - [Limitations](#limitations)
  - [Creating a new Colab notebook](#creating-a-new-colab-notebook)
  - [Sharing notebooks in playground mode](#sharing-notebooks-in-playground-mode)
  - [Code snippets and guidance](#code-snippets-and-guidance)
    - [Fetching data from BigQuery](#fetching-data-from-bigquery)
    - [Fetching data from Google Sheets](#fetching-data-from-google-sheets)
    - [Accepting user input via widgets](#accepting-user-input-via-widgets)
    - [Displaying interactive tables](#displaying-interactive-tables)
    - [Displaying charts](#displaying-charts)
    - [Allowing users to download data](#allowing-users-to-download-data)
    - [Allowing users to copy text to the clipboard](#allowing-users-to-copy-text-to-the-clipboard)
<!--te-->
