```mermaid
---
title: Wishlist Models
---
classDiagram
  direction LR

  class User {
    String email
    String name
  }

  class Wishlist {
    String name
    Boolean public
  }

  class WishlistItem {
    String name
    Text description
    String link
    Float price
    Datetime received_at
  }

  Wishlist o-- User
  Wishlist *-- WishlistItem
```
