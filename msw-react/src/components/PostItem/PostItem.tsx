import { useEffect, useState } from "react";
import styles from "./PostItem.module.css";
import Comment from "../Comments/Comment";
import CONSTANTS from "../../constants";
import IPost from "../../interfaces/Post";
import IComment from "../../interfaces/Comment";

const PostItem = ({ post }: { post: IPost }): JSX.Element => {
  const { id, body, title } = post;
  const [comments, setComments] = useState<IComment[]>([]);
  const [toggleComments, setToggleComments] = useState<boolean>(false);

  useEffect(() => {
    const abortController = new AbortController();

    const fetchComments = async (postId: number) => {
      try {
        const response = await fetch(
          `${CONSTANTS.API_URL}/comments?postId=${postId}`,
          { signal: abortController.signal }
        );
        const data = await response.json();
        setComments(data);
      } catch (error) {
        if ((error as Error).message === "Aborted") {
          return;
        }
        console.log(error);
      }
    };
    fetchComments(id);
    return () => {
      abortController.abort();
    };
  }, [id]);

  return (
    <article className={styles.postItem}>
      <h3>{title}</h3>
      <div>{body}</div>

      {comments.length > 0 ? (
        <button
          className={styles.button}
          onClick={() => setToggleComments(!toggleComments)}
        >
          See comments
        </button>
      ) : (
        <div>No comments yet!</div>
      )}
      <ul className={styles.comments}>
        {toggleComments
          ? comments.map((comment) => (
              <Comment key={comment.id} comment={comment} />
            ))
          : null}
      </ul>
    </article>
  );
};

export default PostItem;
