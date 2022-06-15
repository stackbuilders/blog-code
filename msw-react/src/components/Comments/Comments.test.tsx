import { render, screen } from "@testing-library/react";
import IComment from "../../interfaces/Comment";
import Comment from "./Comment";

const comment: IComment = {
  id: 1,
  body: "Body",
  email: "test@mail.com",
  name: "Comment 1",
};

describe("Comments test suite", () => {
  test("Render component with initial data", () => {
    render(<Comment comment={comment} />);
    screen.getByText(/Body/i);
    screen.getByText(/Posted by: test@mail.com/i);
  });
});
