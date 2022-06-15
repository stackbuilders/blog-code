import React from "react";
import { render, screen } from "@testing-library/react";
import Posts from "./Posts";
import server from "../../mocks/server";
import { rest } from "msw";
import CONSTANTS from "../../constants";

describe("Posts test suite", () => {
  test("Renders the component with loading state", async () => {
    render(<Posts />);
    await screen.findByText(/Loading posts.../i);
  });

  test("Renders the component without posts", async () => {
    server.use(
      rest.get(`${CONSTANTS.API_URL}/posts`, (req, res, ctx) => {
        return res(ctx.status(200), ctx.json([]));
      })
    );
    render(<Posts />);
    await screen.findByText(/No posts published/i);
  });

  test("Renders the component with posts", async () => {
    render(<Posts />);
    const postsItems = await screen.findAllByRole("article");
    expect(postsItems).toHaveLength(2);
  });
});
