create view "ViewTable" ("commentId", "toId", "momentId", "content", "id", "sex", "name", "tag", "head", "contactIdList", "pictureList", "date") as
SELECT "C"."id" AS "commentId",
       "C"."toId",
       "C"."momentId",
       "C"."content",
       "U"."id",
       "U"."sex",
       "U"."name",
       "U"."tag",
       "U"."head",
       "U"."contactIdList",
       "U"."pictureList",
       "U"."date"
FROM "Comment" "C"
         JOIN "apijson_user" "U" ON "U"."id" = "C"."userId";