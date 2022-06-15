import { useEffect, useState } from "react";
import PostItem from "../../components/PostItem/PostItem";
import CONSTANTS from "../../constants";
import IPost from "../../interfaces/Post";
import styles from "./Posts.module.css";

const PostsList = (): JSX.Element => {
  const [posts, setPosts] = useState<IPost[]>([]);
  const [loading, setLoading] = useState<boolean>(false);

  useEffect(() => {
    const abortController = new AbortController();
    const fetchPosts = async () => {
      try {
        setLoading(true);
        const response = await fetch(`${CONSTANTS.API_URL}/posts`, {
          signal: abortController.signal,
        });
        const posts = await response.json();

        setPosts(posts);
      } catch (error) {
        if ((error as Error).message === "Aborted") {
          return;
        }
        console.error((error as Error).message);
      } finally {
        setLoading(false);
      }
    };
    fetchPosts();
    return () => {
      abortController.abort();
    };
  }, []);

  if (loading) {
    return <div>Loading posts...</div>;
  }

  if (posts.length === 0) {
    return <div>No posts published</div>;
  }

  return (
    <section className={styles.posts}>
      <h1>Posting all day!</h1>
      <ul>
        {posts.map((post) => (
          <PostItem key={post.id} post={post} />
        ))}
      </ul>
    </section>
  );
};

export default PostsList;
