import { rest } from "msw";
import CONSTANTS from "../constants";

function getPosts() {
  return rest.get(`${CONSTANTS.API_URL}/posts`, (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json([
        {
          userId: 1,
          id: 1,
          title: "Post 1 title",
          body: "Post 1 body",
        },
        {
          userId: 1,
          id: 2,
          title: "Post 2 title",
          body: "Post 2 body",
        },
      ])
    );
  });
}

function getComments() {
  return rest.get(`${CONSTANTS.API_URL}/comments`, (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json([
        {
          id: 1,
          name: "Comment name 1",
          email: "richosojason@msn.com",
          body: "Comment body 2",
        },
        {
          id: 2,
          name: "Comment name 2",
          email: "rmunoz@stackbuilders.com",
          body: "Comment body 2",
        },
      ])
    );
  });
}

export const handlers = [getPosts(), getComments()];
