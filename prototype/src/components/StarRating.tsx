import { Icon } from './Icon';

type Props = {
  value: number;
  size?: number;
};

/** E8: sao tô đầy, phẳng, màu highlight. */
export function StarRating({ value, size = 14 }: Props) {
  return (
    <span className="inline-flex items-center">
      {Array.from({ length: 5 }, (_, i) => (
        <Icon
          key={i}
          name="star"
          filled
          size={size}
          style={{
            color:
              i < value
                ? 'var(--highlight)'
                : 'color-mix(in srgb, var(--highlight) 28%, var(--tag))',
          }}
        />
      ))}
    </span>
  );
}
