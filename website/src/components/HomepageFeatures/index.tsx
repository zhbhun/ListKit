import type { ReactNode } from "react";
import clsx from "clsx";
import Heading from "@theme/Heading";
import styles from "./styles.module.css";

type FeatureItem = {
  title: string;
  icon: string;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: "数据驱动",
    icon: "💡",
    description: <>通过快照（snapshot）轻松实现数据的动态更新和动画刷新。</>,
  },
  {
    title: "声明式 API",
    icon: "🚀",
    description: (
      <>提供直观、简洁的声明式接口，支持更快速地创建复杂列表布局。</>
    ),
  },
  {
    title: "多场景",
    icon: "🌐",
    description: <>提供了多种列表和布局模式，满足不同使用场景的需求</>,
  },
];

function Feature({ title, icon, description }: FeatureItem) {
  return (
    <div className={clsx("col col--4")}>
      <div className={clsx("text--center", styles.featureIcon)}>{icon}</div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
