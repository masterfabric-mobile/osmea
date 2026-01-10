'use client';

import { useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Switch } from '@/components/ui/switch';
import { toast } from 'sonner';
import { Loader2, Apple, Smartphone, Play, Rocket } from 'lucide-react';

interface BuildTriggerProps {
  onTrigger: (options: BuildOptions) => Promise<void>;
  disabled?: boolean;
}

interface BuildOptions {
  platform: 'ios' | 'android';
  buildType: 'debug' | 'release' | 'adhoc';
  artifactType?: 'ipa' | 'apk' | 'aab';
  environment: 'development' | 'staging' | 'production';
  uploadToStore: boolean;
}

export function BuildTrigger({ onTrigger, disabled = false }: BuildTriggerProps) {
  const [platform, setPlatform] = useState<'ios' | 'android'>('android');
  const [buildType, setBuildType] = useState<'debug' | 'release' | 'adhoc'>('debug');
  const [environment, setEnvironment] = useState<'development' | 'staging' | 'production'>('development');
  const [uploadToStore, setUploadToStore] = useState(false);
  const [triggering, setTriggering] = useState(false);

  const getArtifactType = (): 'ipa' | 'apk' | 'aab' | undefined => {
    if (platform === 'ios') return 'ipa';
    if (buildType === 'release' && uploadToStore) return 'aab';
    return 'apk';
  };

  const handleTrigger = async () => {
    setTriggering(true);
    try {
      await onTrigger({
        platform,
        buildType,
        artifactType: getArtifactType(),
        environment,
        uploadToStore,
      });
      toast.success(`${platform.toUpperCase()} build triggered successfully!`);
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Failed to trigger build';
      toast.error(message);
    } finally {
      setTriggering(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Rocket className="h-5 w-5" />
          Trigger New Build
        </CardTitle>
        <CardDescription>Configure and start a new build</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Platform Selection */}
        <div className="space-y-3">
          <Label>Platform</Label>
          <div className="grid grid-cols-2 gap-3">
            <Button
              type="button"
              variant={platform === 'ios' ? 'default' : 'outline'}
              className="h-20 flex-col gap-2"
              onClick={() => setPlatform('ios')}
              disabled={disabled || triggering}
            >
              <Apple className="h-6 w-6" />
              <span>iOS</span>
            </Button>
            <Button
              type="button"
              variant={platform === 'android' ? 'default' : 'outline'}
              className="h-20 flex-col gap-2"
              onClick={() => setPlatform('android')}
              disabled={disabled || triggering}
            >
              <Smartphone className="h-6 w-6" />
              <span>Android</span>
            </Button>
          </div>
        </div>

        {/* Build Type */}
        <div className="space-y-2">
          <Label htmlFor="buildType">Build Type</Label>
          <Select
            value={buildType}
            onValueChange={(value) => setBuildType(value as typeof buildType)}
            disabled={disabled || triggering}
          >
            <SelectTrigger id="buildType">
              <SelectValue placeholder="Select build type" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="debug">Debug</SelectItem>
              <SelectItem value="release">Release</SelectItem>
              {platform === 'ios' && <SelectItem value="adhoc">Ad Hoc</SelectItem>}
            </SelectContent>
          </Select>
        </div>

        {/* Environment */}
        <div className="space-y-2">
          <Label htmlFor="environment">Environment</Label>
          <Select
            value={environment}
            onValueChange={(value) => setEnvironment(value as typeof environment)}
            disabled={disabled || triggering}
          >
            <SelectTrigger id="environment">
              <SelectValue placeholder="Select environment" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="development">Development</SelectItem>
              <SelectItem value="staging">Staging</SelectItem>
              <SelectItem value="production">Production</SelectItem>
            </SelectContent>
          </Select>
        </div>

        {/* Upload to Store */}
        {buildType === 'release' && (
          <div className="flex items-center justify-between p-4 bg-muted rounded-lg">
            <div>
              <Label htmlFor="uploadToStore" className="text-base font-medium">
                Upload to Store
              </Label>
              <p className="text-sm text-muted-foreground">
                {platform === 'ios' ? 'Upload to TestFlight' : 'Upload to Play Console'}
              </p>
            </div>
            <Switch
              id="uploadToStore"
              checked={uploadToStore}
              onCheckedChange={setUploadToStore}
              disabled={disabled || triggering}
            />
          </div>
        )}

        {/* Summary */}
        <div className="p-4 bg-muted/50 rounded-lg space-y-2">
          <h4 className="font-medium">Build Summary</h4>
          <div className="text-sm text-muted-foreground space-y-1">
            <p>Platform: <span className="font-medium text-foreground capitalize">{platform}</span></p>
            <p>Type: <span className="font-medium text-foreground capitalize">{buildType}</span></p>
            <p>Environment: <span className="font-medium text-foreground capitalize">{environment}</span></p>
            <p>Artifact: <span className="font-medium text-foreground uppercase">{getArtifactType()}</span></p>
            {uploadToStore && buildType === 'release' && (
              <p className="text-blue-600">Will upload to {platform === 'ios' ? 'TestFlight' : 'Play Console'}</p>
            )}
          </div>
        </div>

        {/* Trigger Button */}
        <Button
          onClick={handleTrigger}
          disabled={disabled || triggering}
          className="w-full"
          size="lg"
        >
          {triggering ? (
            <>
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              Triggering Build...
            </>
          ) : (
            <>
              <Play className="mr-2 h-4 w-4" />
              Start Build
            </>
          )}
        </Button>
      </CardContent>
    </Card>
  );
}
