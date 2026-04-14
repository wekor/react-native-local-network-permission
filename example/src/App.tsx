import { useState } from 'react';
import { Text, View, StyleSheet, Button } from 'react-native';
import { requestPermission } from '@wekor/react-native-local-network-permission';

export default function App() {
  const [granted, setGranted] = useState<boolean | null>(null);

  const handleRequest = async () => {
    const result = await requestPermission();
    setGranted(result);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Local Network Permission</Text>

      <Button title="Request Permission" onPress={handleRequest} />

      {granted !== null && (
        <View style={styles.result}>
          <Text>Granted: {granted ? 'Yes' : 'No'}</Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  result: {
    marginTop: 20,
    padding: 16,
    backgroundColor: '#f0f0f0',
    borderRadius: 8,
  },
});
