import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { rest } from "msw";
import CONSTANTS from "../../constants";
import IPost from "../../interfaces/Post";
import server from "../../mocks/server";
import PostItem from "./PostItem";

const post: IPost = {
  id: 1,
  body: "Body",
  title: "Title",
};

describe("PostItem test suite", () => {
  test("Render PostItem component with post data", () => {
    render(<PostItem post={post} />);
    screen.getByRole("heading", { name: /Title/i });
    screen.getByText(/Body/i);
  });

  test("PostItem doesn't have comments", async () => {
    server.use(
      rest.get(`${CONSTANTS.API_URL}/comments`, (req, res, ctx) => {
        return res(ctx.status(200), ctx.json([]));
      })
    );
    render(<PostItem post={post} />);
    await waitFor(() => screen.getByText(/No comments yet!/i));
  });

  test("PostItem has comments", async () => {
    render(<PostItem post={post} />);
    await waitFor(() => {
      const button = screen.getByRole("button", { name: /See comments/i });
      userEvent.click(button);
      const comments = screen.getAllByRole("listitem");
      expect(comments).toHaveLength(2);
    });
  });
});
